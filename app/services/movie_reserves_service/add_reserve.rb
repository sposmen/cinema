module MovieReservesService
  class AddReserve
    include Dry::Transaction

    step :validate
    step :add

    def validate(date_range)
      unless date_range[:from].is_a?(Date) && date_range[:to].is_a?(Date) && date_range[:to] >= date_range[:from]
        Failure(OpenStruct.new(
          errors: {error: INVALID_DAY_MSG}
        ))
      end
      Success(date_range)
    end

    def add(date_range)

    end
  end
end
