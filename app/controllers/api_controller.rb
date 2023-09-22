class ApiController < ActionController::Base
    # skip CSRF check
    # Ref: https://ihower.tw/rails/fullstack-web-api-design.html
    skip_before_action :verify_authenticity_token

end
