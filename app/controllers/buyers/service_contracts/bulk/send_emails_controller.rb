# frozen_string_literal: true

class Buyers::ServiceContracts::Bulk::SendEmailsController < Buyers::ServiceContracts::Bulk::BaseController
  def create
    send_emails
    handle_errors
  end

  private

  def recipients
    @recipients ||= service_contracts.map(&:user_account)
  end
end
