class PdfsController < ApplicationController

  require 'rmagick'

  before_action :set_pdf, only: [:show, :edit, :update, :destroy, :download, :show_page]

  # GET /pdfs
  # GET /pdfs.json
  def index
    @pdfs = Pdf.all
  end

  # GET /pdfs/1
  # GET /pdfs/1.json
  def show
  end

  # GET /pdfs/new
  def new
    @pdf = Pdf.new
  end

  # GET /pdfs/1/edit
  def edit
  end

  # GET /pdfs/1/download
  def download
    send_file(@pdf.file.path,
              :filename => @pdf.name + '.pdf',
              :type  => @pdf.file.content_type,
              :disposition => 'attachment',
              :url_based_filename => true)
  end

  # GET /pdfs/1/pages/1
  def show_page
    @page = @pdf.pdf_pages.find_by(:page => params[:page_id])
    send_file( @page.path, type: "image/png", disposition: "inline")
  end

  # POST /pdfs
  # POST /pdfs.json
  def create
    @pdf = Pdf.new(pdf_params)

    respond_to do |format|
      if @pdf.save
        format.html { redirect_to @pdf, notice: 'Pdf was successfully created.' }
        format.json { render :show, status: :created, location: @pdf }

        pdf_pages_create
      else
        format.html { render :new }
        format.json { render json: @pdf.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /pdfs/1
  # PATCH/PUT /pdfs/1.json
  def update
    pdf_pages_destroy

    respond_to do |format|
      if @pdf.update(pdf_params)
        format.html { redirect_to @pdf, notice: 'Pdf was successfully updated.' }
        format.json { render :show, status: :ok, location: @pdf }

        pdf_pages_create
      else
        format.html { render :edit }
        format.json { render json: @pdf.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pdfs/1
  # DELETE /pdfs/1.json
  def destroy
    pdf_pages_destroy

    @pdf.destroy
    respond_to do |format|
      format.html { redirect_to pdfs_url, notice: 'Pdf was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_pdf
    @pdf = Pdf.find(params[:id] || params[:pdf_id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def pdf_params
    params.require(:pdf).permit(:name, :file)
  end

  def pdf_pages_create
    @images = Magick::ImageList::new(@pdf.file.path) do
      self.format = 'PDF'
      self.quality = 100
      self.density = 144
      self.channel
    end
    @images.each_with_index  do |img, index|
      path = "./public#{@pdf.file.url}.#{index}.png"

      @page = PdfPage.new
      @page.page = index
      @page.path = path
      @page.pdf = @pdf
      @page.save

      img.write(path) { self.format = "png" }
    end
  end

  def pdf_pages_destroy
    @pdf.pdf_pages.each do |page|
      File.delete(page.path)
      page.destroy
    end
  end
end
