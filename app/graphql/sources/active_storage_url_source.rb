# frozen_string_literal: true

module Sources
  class ActiveStorageUrlSource < GraphQL::Dataloader::Source
    def initialize(attachment_name)
      @attachment_name = attachment_name
    end

    def fetch(records)
      ActiveRecord::Associations::Preloader.new(
        records: records,
        associations: { "#{@attachment_name}_attachment": :blob }
      ).call

      records.map do |record|
        attachment = record.public_send(@attachment_name)
        next unless attachment.attached?

        Rails.application.routes.url_helpers.rails_blob_url(attachment, host: host)
      end
    end

    private

    def host
      Rails.application.config.action_mailer.default_url_options&.fetch(:host, 'localhost')
    end
  end
end
