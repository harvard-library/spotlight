# frozen_string_literal: true

module Spotlight
  # Handles requests to upload images for exhibit thumbnails
  class FeaturedImagesController < Spotlight::ApplicationController
    skip_before_action :verify_authenticity_token
    load_and_authorize_resource instance_name: :featured_image
    
    def create
      if @featured_image.save && @featured_image.file_present?
        render json: { tilesource: tilesource, id: @featured_image.id }
      else
        render json: { error: 'unable to create image' }, status: :bad_request
      end
    end

    private

    def tilesource
      riiif.info_url(@featured_image.id)
    end

    # The create action can be called from a number of different forms, so
    # we normalize all the parameters.
    def create_params
      params.require(:featured_image).permit(:image)
    end
  end
end
