class ArchitectsController < ApplicationController
  # GET /architects
  # GET /architects.xml
  def index
    @architects = Architect.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @architects }
    end
  end

  # GET /architects/1
  # GET /architects/1.xml
  def show
    @architect = Architect.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @architect }
    end
  end

  # GET /architects/new
  # GET /architects/new.xml
  def new
    @architect = Architect.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @architect }
    end
  end

  # GET /architects/1/edit
  def edit
    @architect = Architect.find(params[:id])
  end

  # POST /architects
  # POST /architects.xml
  def create
    @architect = Architect.new(params[:architect])

    respond_to do |format|
      if @architect.save
        flash[:notice] = 'Architect was successfully created.'
        format.html { redirect_to(@architect) }
        format.xml  { render :xml => @architect, :status => :created, :location => @architect }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @architect.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /architects/1
  # PUT /architects/1.xml
  def update
    @architect = Architect.find(params[:id])

    respond_to do |format|
      if @architect.update_attributes(params[:architect])
        flash[:notice] = 'Architect was successfully updated.'
        format.html { redirect_to(@architect) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @architect.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /architects/1
  # DELETE /architects/1.xml
  def destroy
    @architect = Architect.find(params[:id])
    @architect.destroy

    respond_to do |format|
      format.html { redirect_to(architects_url) }
      format.xml  { head :ok }
    end
  end
end
