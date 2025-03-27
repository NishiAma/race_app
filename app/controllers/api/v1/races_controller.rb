module Api
  module V1
    class RacesController < BaseController
      before_action :set_race, only: [:show, :update]

      def index
        races = Race.order(updated_at: :desc)
        render json: races
      end

      def show
        render json: @race.as_json(include: {
          race_students: {
            include: {
              student: { only: [:id, :name, :age] }
            }
          }
        })
      end

      def create
        Rails.logger.debug "Received Params: #{params.inspect}"
 
        if race_students_params.size < 2
          render json: { error: "Race must have at least two students" }, 
                 status: :unprocessable_entity
          return
        end

        ActiveRecord::Base.transaction do
          @race = Race.new(race_params)
          
          if @race.save
            create_race_students
            render json: @race, status: :created
          else
            render json: { errors: @race.errors }, status: :unprocessable_entity
          end
        end
      rescue StandardError => e
        render json: { error: e.message }, status: :unprocessable_entity
      end

      def update
        ActiveRecord::Base.transaction do
          @race.completed!
          
          race_students_places_params.each do |student_params|
            race_student = @race.race_students.find(student_params[:id])
            race_student.update!(place: student_params[:place])
          end

          render json: @race.as_json(include: {
            race_students: {
              include: {
                student: { only: [:id, :name, :age] }
              }
            }
          })
        end
      rescue ActiveRecord::RecordNotFound => e
        render json: { error: 'Race student not found' }, status: :not_found
      rescue StandardError => e
        render json: { error: e.message }, status: :unprocessable_entity
      end

      private

      def set_race
        @race = Race.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: 'Race not found' }, status: :not_found
      end

      def race_params
        params.require(:race).permit(:name, :status, race_students: [:student_id, :lane])
      end


      def race_students_params
        params.require(:race).permit(race_students: [:student_id, :lane])[:race_students] || []
      end

      def race_students_places_params
        params.require(:race).permit(race_students: [:id, :place])[:race_students] || []
      end

      def create_race_students
        race_students_params.each do |student_params|
          @race.race_students.create!(student_params)
        end
      end
    end
  end
end 