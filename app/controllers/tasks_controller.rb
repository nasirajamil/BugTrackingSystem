require "google/apis/calendar_v3"
require "google/api_client/client_secrets.rb"

class TasksController < ApplicationController
  CALENDAR_ID = 'primary'

  def new
    @task = Task.new
  end

  def create
    client = get_google_calendar_client(current_user)
    task = params[:task]
    event = get_event task
    client.insert_event('primary', event)
    flash[:notice] = 'Task was successfully added.'
    redirect_to tasks_path
  end

  def get_google_calendar_client(current_user)
    client = Google::Apis::CalendarV3::CalendarService.new
    return unless (current_user.present?)
    secrets = Google::APIClient::ClientSecrets.new({ "web" => {
        "access_token" => current_user.access_token,
        "refresh_token" => current_user.refresh_token,
        "client_id" => '173797359177-gb4e7qcsdvhqspn198qpifo7ff28ki6u.apps.googleusercontent.com',
        "client_secret" => 'Q2xa1sHGgpXTpkVjhjzUqw6t'
      }
    })
    begin
      client.authorization = secrets.to_authorization
      client.authorization.grant_type = "refresh_token"

      if !current_user.present?
        client.authorization.refresh!
        current_user.update_attributes(
          access_token: client.authorization.access_token,
          refresh_token: client.authorization.refresh_token,
          expires_at: client.authorization.expires_at.to_i
        )
      end
    rescue => e
      flash[:error] = 'Your token has been expired. Please login again with google.'
      redirect_to :back
    end
    client
  end

  private

  def get_event task
    attendees = task[:members].split(',').map{ |t| {email: t.strip} }
    event = Google::Apis::CalendarV3::Event.new({
                                                  summary: task[:title],
                                                  location: '800 Howard St., San Francisco, CA 94103',
                                                  description: task[:description],
                                                  start: {
                                                    date_time: Time.new(task['start_date(1i)'],task['start_date(2i)'],task['start_date(3i)'],task['start_date(4i)'],task['start_date(5i)']).to_datetime.rfc3339,
                                                    time_zone: "Asia/Karachi"
                                                  },
                                                  end: {
                                                    date_time: Time.new(task['end_date(1i)'],task['end_date(2i)'],task['end_date(3i)'],task['end_date(4i)'],task['end_date(5i)']).to_datetime.rfc3339,
                                                    time_zone: "Asia/Karachi"
                                                  },
                                                  attendees: attendees,
                                                  reminders: {
                                                    use_default: false,
                                                    overrides: [
                                                      Google::Apis::CalendarV3::EventReminder.new(reminder_method:"popup", minutes: 10),
                                                      Google::Apis::CalendarV3::EventReminder.new(reminder_method:"email", minutes: 20)
                                                    ]
                                                  },
                                                  notification_settings: {
                                                    notifications: [
                                                      {type: 'event_creation', method: 'email'},
                                                      {type: 'event_change', method: 'email'},
                                                      {type: 'event_cancellation', method: 'email'},
                                                      {type: 'event_response', method: 'email'}
                                                    ]
                                                  }, 'primary': true
                                                })
  end
  def google_oauth2
    @user = User.from_omniauth(request.env["omniauth.auth"])
    if @user.persisted?
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Google"
      auth = request.env["omniauth.auth"]
      @user.access_token = auth.credentials.token
      @user.expires_at = auth.credentials.expires_at
      @user.refresh_token = auth.credentials.refresh_token
      @user.save!
      sign_in(@user)
      redirect_to tasks_path
    else
      session["devise.google_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end
end
