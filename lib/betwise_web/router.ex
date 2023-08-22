defmodule BetwiseWeb.Router do
  alias BetwiseWeb.UserLive.SysUsers
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

  scope "/users" do
    pipe_through [:browser, :require_authenticated_user]

    live_session :users,
      on_mount: [{BetwiseWeb.Auth.UserAuth, :mount_current_user}] do
      live "/", BetwiseWeb.UserLive.SysUsers
    end
  end
end
