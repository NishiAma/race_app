module Api
  module V1
    class RacesController < ApplicationController
      def index
        races = Race.order(updated_at: :desc)
        render json: races
      end

      def create
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
        @race = Race.find(params[:id])

        ActiveRecord::Base.transaction do
          @race.status = :completed
          update_race_students_places
          
          if @race.save
            render json: @race
          else
            render json: { errors: @race.errors }, status: :unprocessable_entity
          end
        end
      rescue ActiveRecord::RecordNotFound
        render json: { error: 'Race not found' }, status: :not_found
      rescue StandardError => e
        render json: { error: e.message }, status: :unprocessable_entity
      end

      private

      def race_params
        params.require(:race).permit(:name, :status)
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

      def update_race_students_places
        race_students_places_params.each do |student_params|
          race_student = @race.race_students.find(student_params[:id])
          race_student.update!(place: student_params[:place])
        end
      end
    end
  end
end 