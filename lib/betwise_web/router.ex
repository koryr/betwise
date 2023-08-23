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
      live "/p/:email", Profile
    end
  end

  scope "/sports", BetwiseWeb.Sports, as: :sports do
    pipe_through [:browser, :require_authenticated_user]

    live_session :sports,
      on_mount: [{BetwiseWeb.Auth.UserAuth, :mount_current_user}] do
      live "/sport-types", SportTypeLive.Index, :index
      live "/sport-types/new", SportTypeLive.Index, :new
      live "/sport-types/:id/edit", SportTypeLive.Index, :edit

      live "/sport-types/:id", SportTypeLive.Show, :show
      live "/sport-types/:id/show/edit", SportTypeLive.Show, :edit

      live "/teams", TeamLive.Index, :index
      live "/teams/new", TeamLive.Index, :new
      live "/teams/:id/edit", TeamLive.Index, :edit

      live "/teams/:id", TeamLive.Show, :show
      live "/teams/:id/show/edit", TeamLive.Show, :edit


      live "/bet_types", BetTypeLive.Index, :index
      live "/bet_types/new", BetTypeLive.Index, :new
      live "/bet_types/:id/edit", BetTypeLive.Index, :edit

      live "/bet_types/:id", BetTypeLive.Show, :show
      live "/bet_types/:id/show/edit", BetTypeLive.Show, :edit


      live "/games", GameLive.Index, :index
      live "/games/new", GameLive.Index, :new
      live "/games/:id/edit", GameLive.Index, :edit

      live "/games/:id", GameLive.Show, :show
      live "/games/:id/show/edit", GameLive.Show, :edit

      live "/selections", SelectionLive.Index, :index
      live "/selections/new", SelectionLive.Index, :new
      live "/selections/:id/edit", SelectionLive.Index, :edit

      live "/selections/:id", SelectionLive.Show, :show
      live "/selections/:id/show/edit", SelectionLive.Show, :edit


      live "/markets", MarketLive.Index, :index
      live "/markets/new", MarketLive.Index, :new
      live "/markets/:id/edit", MarketLive.Index, :edit

      live "/markets/:id", MarketLive.Show, :show
      live "/markets/:id/show/edit", MarketLive.Show, :edit

    end
  end


end
