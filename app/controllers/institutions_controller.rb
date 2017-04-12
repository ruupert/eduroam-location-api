class InstitutionsController < ApplicationController
include InstitutionsHelper
  before_action :set_institution, only: [:show, :edit, :update, :destroy]


  # GET /institutions
  # GET /institutions.json
  def index
    @institutions = Institution.all
  end

  # GET /institutions/1
  # GET /institutions/1.json
  def show
  end

  # GET /institutions/new
  def new
    @institution = Institution.new
    @institution.orgnames.build
    @institution.orgpolicies.build
    @institution.orginfos.build
    @institution.orgssids.build
    @countries = ISO3166::Country.codes
    @institution_types = {'IdP&SP' => 3, 'SP' => 2}
  end

  # GET /institutions/1/edit
  def edit
    @institution = Institution.find(params[:id])
    @institution.orgnames.build
    @institution.orgpolicies.build
    @institution.orginfos.build
    @institution.orgssids.build

    @countries = ISO3166::Country.codes
    @institution_types = {'IdP&SP' => 3, 'SP' => 2}
  end

  # POST /institutions
  # POST /institutions.json

  #  Parameters: {"utf8"=>"✓",
  # "authenticity_token"=>"QrmsUkCUesfW7OWpr3al5nmKBwywyzGIfqKW
  # prkqoopGKTpUkBwEihJw4PODVtPOrXcSjQAfYdBLTBhmH0Bi5g==",
  # "institution"=>{"institution_type"=>"3",
  # "orgname"=>{"name"=>"HelloUniversity"},
  # "inst_realm"=>"lauttasaari.fi",
  # "address"=>"Lauttasaarentie 10",
  # "city"=>"Helsinki", "contact_name"=>"Raul Becker",
  # "contact_email"=>"raul.becker@iki.fi",
  # "contact_phone"=>"050505050",
  # "orginfo"=>{"url"=>"lauttasaari.fi/info_english"},
  # "orgpolicy"=>{"url"=>"http://lauttasaari.fi/policy_english"}},
  # "commit"=>"Create Institution"}

  def create
    @institution = Institution.new(institution_params)

    respond_to do |format|
      if @institution.save
        format.html { redirect_to @institution, notice: 'Institution was successfully created.' }
        format.json { render :show, status: :created, location: @institution }
      else
        format.html { render :new }
        format.json { render json: @institution.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /institutions/1
  # PATCH/PUT /institutions/1.json
  def update
    respond_to do |format|
      if @institution.update(institution_params)
        format.html { redirect_to @institution, notice: 'Institution was successfully updated.' }
        format.json { render :show, status: :ok, location: @institution }
      else
        format.html { render :edit }
        format.json { render json: @institution.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /institutions/1
  # DELETE /institutions/1.json
  def destroy
    @institution.destroy
    respond_to do |format|
      format.html { redirect_to institutions_url, notice: 'Institution was successfully destroyed.' }
      format.json { head :no_content }
    end
  end


  def new_import

  end

  def import


    file_data = params[:file]

    if file_data.respond_to?(:read)
      xml_contents = file_data.read
      import_data xml_contents

      flash[:success] = "<strong>File Imported!</strong>"
      redirect_to institutions_url

    elsif file_data.respond_to?(:path)
      xml_contents = File.read(file_data.path)
      import_data xml_contents
      flash[:success] = "<strong>File Imported!</strong>"
      redirect_to institutions_url
    else
      logger.error "Bad file_data: #{file_data.class.name}: #{file_data.inspect}"
      flash[:error] = "There was a problem importing the file.<br>
      <strong>#{exception.message}</strong><br>"
      redirect_to import

    end


  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_institution
    @institution = Institution.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def institution_params
    params.require(:institution).permit(:country,
                                        :institution_type,
                                        :inst_realm,
                                        :address,
                                        :city,
                                        :contact_name,
                                        :contact_email,
                                        :contact_phone,
                                        orgnames_attributes: [:lang, :name],
                                        orgpolicies_attributes: [:lang, :url],
                                        orginfos_attributes: [:lang, :url],
                                        orgssids_attributes: [:number, :wpa_tkip, :wpa_aes, :wpa2_tkip, :wpa2_aes, :port_restrict, :transp_proxy, :ipv6, :nat])

  end
end
