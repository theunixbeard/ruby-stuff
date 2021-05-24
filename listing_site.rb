class ListingSite < ActiveRecord::Base
  belongs_to :listing, inverse_of: :listing_sites
  has_one :seller, through: :listing, source: :seller

  validates :url, allow_nil: false, length: { maximum: 512 }, http_url: true

  scope :google_analytics_update_metrics, lambda {
    joins(:listing)
      .joins(:seller)
      .where("
      (
        listings.listing_status IN ('For Sale', 'For Publishing', 'Pending Sold')
        OR listings.vetting_status IN ('#{Models::Listings::Constants.in_vetting_statuses.join("','")}')
      )
      AND users.google_refresh_token_ciphertext IS NOT NULL
      AND users.google_access_removed_at IS NULL
      AND (
        listing_sites.google_analytics_metrics_updated_at<?
        OR listing_sites.google_analytics_metrics_updated_at IS NULL
      )
    ",
    Time.now.beginning_of_month)
  }
end
