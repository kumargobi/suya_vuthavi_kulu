class GalleriesController < ApplicationController

def index
  @galleries = Gallery.order("name")
end

def new
  @gallery = Gallery.new
end

def create
  @gallery = Gallery.new(params[:gallery])
  @gallery.save!
end

def edit
  @gallery = Gallery.find(params[:id])
end

def update
  @gallery = Gallery.find(params[:id])
  @gallery.update_attributes!(params[:gallery])
end

def destroy
  @gallery = Gallery.find(params[:id])
  @gallery.destroy
end

def images
  @gallery = Gallery.find(params[:id])
end

def create_image
  image = Image.new(params[:image])
  image.save
  redirect_to images_gallery_path(image.gallery)
end

end