# frozen_string_literal: true

class Movie < Sequel::Model
  plugin :validation_helpers

  def validate
    validates_presence %i[name days_shown]
    validates_integer :days_shown
    errors.add(:image_url, 'is not a valid URL') if image_url && image_url !~ %r{\Ahttps?://}
    errors.add(:days_shown, 'Error setting days') if !days_shown || days_shown < 0 || days_shown > 127
  end
end
