module Api
  module V1
    class StudentsController < ApplicationController
      before_action :set_student, only: [:show, :update, :destroy]

      def index
        students = Student.all
        render json: students
      end

      def show
        render json: @student
      end

      def create
        student = Student.new(student_params)

        if student.save
          render json: student, status: :created
        else
          render json: { errors: student.errors }, status: :unprocessable_entity
        end
      end

      def update
        if @student.update(student_params)
          render json: @student
        else
          render json: { errors: @student.errors }, status: :unprocessable_entity
        end
      end

      def destroy
        if @student.destroy
          head :no_content
        else
          render json: { errors: @student.errors }, status: :unprocessable_entity
        end
      end

      private

      def set_student
        @student = Student.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: 'Student not found' }, status: :not_found
      end

      def student_params
        params.require(:student).permit(:name, :age)
      end
    end
  end
end 