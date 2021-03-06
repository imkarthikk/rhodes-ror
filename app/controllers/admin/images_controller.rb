class Admin::ImagesController < ApplicationController
  
  before_filter :require_login
  
  layout 'admin/layouts/application'
   
  def new
    @image = Image.new
  end


  def create
    @image = Image.new(params[:image])
    
    @material = Material.find(params[:image][:material_id])
    return if @material.nil?
        
      respond_to do |format|
        if @image.save  
                
          # set as default image and search icon image if it's the only image in gallery
          @material.set_default_image(@image.id) if @material.images.count == 1
          @material.set_search_icon_image(@image.id) if @material.images.count == 1
          # @material.
          
          format.html { redirect_to edit_admin_material_path(@material), notice: 'Image was successfully added.' }
          format.json { render json: @image, status: :created, location: @image }
      else
        format.html { redirect_to edit_admin_material_path(@material), alert: 'Problem uploading Image' }
        format.json { render json: @image.errors, status: :unprocessable_entity }
      end
    end
  end


  def update_finish_id
    image_id = params[:image_id]
    finish_id = params[:finish_id]

    return unless @image = Image.find(image_id.to_i)
    
    respond_to do |format|      
      if @image.set_finish(finish_id)
        format.json { render json: { type: 'ok', status: :success } }
      else
        format.json { render json: @image.errors, status: :unprocessable_entity }
      end
    end       
  end


  def update_min_thickness
    image_id = params[:image_id].to_i
    min_thickness = params[:min_thickness].to_s
    
    return unless image_id.is_a?(Numeric) and min_thickness.is_a?(String)
    # return unless min_thickness.is_a?(String) and min_thickness.is_a?(String)
    
    @image = Image.find(image_id)  
    return if @image.nil? 
   
    respond_to do |format|      
      if @image.set_min_thickness min_thickness
        format.json { render json: { type: 'ok', status: :success } }
      else
        format.json { render json: @image.errors, status: :unprocessable_entity }
      end
    end       
  end

  def destroy    
    @image = Image.find(params[:id])
    @material = Material.find(@image.material_id)
    
    # TODO - move this part into model
    # set a new alternative default_image_id if the current one is getting axed
    
    if @material.default_image_id == @image.id
      if @material.images.count > 1
        if @material.images.first.id != @image.id
          @material.default_image_id = @material.images.first.id
        else
          @material.default_image_id = @material.images.last.id
        end
      else
        @material.default_image_id = nil # unset if no images
      end 
      @material.save!
    end    
          
    # detatch/delete all related paperclip images
    @image.image = nil
    @image.save 
    @image.destroy

    respond_to do |format|
      format.html { redirect_to edit_admin_material_path(@material), notice: 'Image was removed' }
      format.json { render json: { type: 'ok', status: :success } }
    end
  end
end
