defmodule BetwiseWeb.Router do

  alias BetwiseWeb.UserLive.Profile
  alias BetwiseWeb.DashboardLive
  use BetwiseWeb, :router

  import BetwiseWeb.Auth.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {BetwiseWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  # scope "/", BetwiseWeb do
  #   pipe_through :browser

  #   get "/", PageController, :home
  # end
  scope "/" do
    pipe_through [:browser, :require_authenticated_user]

    live_session :user,
      on_mount: [{BetwiseWeb.Auth.UserAuth, :mount_current_user}] do
      live "/", DashboardLive
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", BetwiseWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:betwise, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: BetwiseWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  ## Authentication routes

  scope "/auth", BetwiseWeb.Auth, as: :auth do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    live_session :redirect_if_user_is_authenticated,
      on_mount: [{BetwiseWeb.Auth.UserAuth, :redirect_if_user_is_authenticated}] do
      live "/users/register", UserRegistrationLive, :new
      live "/users/log_in", UserLoginLive, :new
      live "/users/reset_password", UserForgotPasswordLive, :new
      live "/users/reset_password/:token", UserResetPasswordLive, :edit
    end

    post "/users/log_in", UserSessionController, :create
  end

  scope "/auth", BetwiseWeb.Auth, as: :auth do
    pipe_through [:browser, :require_authenticated_user]

    live_session :require_authenticated_user,
      on_mount: [{BetwiseWeb.Auth.UserAuth, :ensure_authenticated}] do
      live "/users/settings", UserSettingsLive, :edit
      live "/users/settings/confirm_email/:token", UserSettingsLive, :confirm_email
    end
  end

  scope "/auth", BetwiseWeb.Auth, as: :auth do
    pipe_through [:browser]

    delete "/users/log_out", UserSessionController, :delete

    live_session :current_user,
      on_mount: [{BetwiseWeb.Auth.UserAuth, :mount_current_user}] do
      live "/users/confirm/:token", UserConfirmationLive, :edit
      live "/users/confirm", UserConfirmationInstructionsLive, :new
    end
  end

  scope "/auth", BetwiseWeb.Auth, as: :auth do
    pipe_through :browser

    live_session :role_current_user,
      on_mount: [{BetwiseWeb.Auth.UserAuth, :mount_current_user}] do
      live "/roles", RoleLive.Index, :index
      live "/roles/new", RoleLive.Index, :new
      live "/roles/:id/edit", RoleLive.Index, :edit

      live "/roles/:id", RoleLive.Show, :show
      live "/roles/:id/show/edit", RoleLive.Show, :edit
    end
  end

  scope "/users", BetwiseWeb, as: :users do
    pipe_through [:browser, :require_authenticated_user]

    live_session :users,
      on_mount: [{BetwiseWeb.Auth.UserAuth, :mount_current_user}] do
      live "/", UserLive.SysUsers, :index
      live "/new", UserLive.SysUsers, :new
      live "/:id", UserLive.Show, :show
      live "/:id/show/edit", UserLive.Show, :edit
      live "/p/:email", UserLive.Profile, :index
    end
  end

  scope "/sports", BetwiseWeb.SportsLive, as: :sports do
    pipe_through [:browser, :require_authenticated_user]

    live_session :sports,
      on_mount: [{BetwiseWeb.Auth.UserAuth, :mount_current_user}] do
      live "/sport-types", SportTypes.Index, :index
      live "/sport-types/new", SportTypes.Index, :new
      live "/sport-types/:id/edit", SportTypes.Index, :edit

      live "/sport-types/:id", SportTypes.Show, :show
      live "/sport-types/:id/show/edit", SportTypes.Show, :edit

      live "/teams", Teams.Index, :index
      live "/teams/new", Teams.Index, :new
      live "/teams/:id/edit", Teams.Index, :edit

      live "/teams/:id", Teams.Show, :show
      live "/teams/:id/show/edit", Teams.Show, :edit


      live "/bet_types", BetTypes.Index, :index
      live "/bet_types/new", BetTypes.Index, :new
      live "/bet_types/:id/edit", BetTypes.Index, :edit

      live "/bet_types/:id", BetTypes.Show, :show
      live "/bet_types/:id/show/edit", BetTypes.Show, :edit


      live "/games", Games.Index, :index
      live "/games/new", Games.Index, :new
      live "/games/:id/edit", Games.Index, :edit

      live "/games/:id", Games.Show, :show
      live "/games/:id/show/edit", Games.Show, :edit

      live "/selections", Selections.Index, :index
      live "/selections/new", Selections.Index, :new
      live "/selections/:id/edit", Selections.Index, :edit

      live "/selections/:id", Selections.Show, :show
      live "/selections/:id/show/edit", Selections.Show, :edit


      live "/markets", Markets.Index, :index
      live "/markets/new", Markets.Index, :new
      live "/markets/:id/edit", Markets.Index, :edit

      live "/markets/:id", Markets.Show, :show
      live "/markets/:id/show/edit", Markets.Show, :edit

      live "/highlights", Highlights, :index

      live "/bets", PlacedBets, :index

    end
  end


end
