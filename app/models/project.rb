class Project < ApplicationRecord

  def formatted_start_date
    start_date.strftime("%d-%m-%y") if start_date
  end

  def formatted_end_date
    end_date.strftime("%d-%m-%y") if end_date
  end

  validates :title, presence: true
  validates :description, presence: true  #, length: { minimum: 40 }
  validates :start_date, presence: true
  validates :end_date, presence: true

  validate :end_date_after_start_date    # To ensure end date is after start date


  def end_date_after_start_date
    if end_date.present? && start_date.present? && end_date < start_date
      errors.add(:end_date, "must be after the start date")
    end
  end
end
