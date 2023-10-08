class SpacesController < ApplicationController
  before_action :authenticate_user
  skip_before_action :verify_authenticity_token

  def index
    @spaces = Space.all.order(:title).page params[:page]
  end

  def show
  end

  def update
    new_tags = []
    update_params[:tags].split(',').each do |tag_name|
      tag = Tag.find_by(name: tag_name)
      unless tag
        tag = Tag.create(name: tag_name, color: random_color)
      end
      new_tags << tag
    end
    space.tags = new_tags
    if update_params[:cover_image].present?
      image_url_code = AliyunOss.instance.upload 'space-cover', update_params[:cover_image]
      space.cover_image = image_url_code
    end
    space.space_type = update_params[:space_type]
    if space.save
      render json: {
        message: 'Space Saved',
        tags: space.tags.to_json,
        cover_image: space.cover_image_url,
        space_type: space.readable_type
      }
    else
      render json: {message: 'Failed to Save'}, status: 500
    end
  end

  private

  def space
    @space ||= Space.find_by!(space_starchain_id: params[:id])
  end

  def update_params
    params.permit(:id, :tags, :cover_image, :space_type)
  end

  def random_color
    "##{random_color_hex}"
  end

  def random_color_hex
    "%06x" % (rand * 0xffffff)
  end
end