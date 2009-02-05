class TheatersController < ApplicationController
  # GET /theaters
  # GET /theaters.xml
  def index
    @theaters = Theater.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @theaters }
    end
  end

  # GET /theaters/1
  # GET /theaters/1.xml
  def show
    @theater = Theater.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @theater }
    end
  end

  # GET /theaters/new
  # GET /theaters/new.xml
  def new
    @theater = Theater.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @theater }
    end
  end

  # GET /theaters/1/edit
  def edit
    @theater = Theater.find(params[:id])
  end

  # POST /theaters
  # POST /theaters.xml
  def create
    @theater = Theater.new(params[:theater])

    respond_to do |format|
      if @theater.save
        flash[:notice] = 'Theater was successfully created.'
        format.html { redirect_to(@theater) }
        format.xml  { render :xml => @theater, :status => :created, :location => @theater }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @theater.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /theaters/1
  # PUT /theaters/1.xml
  def update
    @theater = Theater.find(params[:id])

    respond_to do |format|
      if @theater.update_attributes(params[:theater])
        flash[:notice] = 'Theater was successfully updated.'
        format.html { redirect_to(@theater) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @theater.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /theaters/1
  # DELETE /theaters/1.xml
  def destroy
    @theater = Theater.find(params[:id])
    @theater.destroy

    respond_to do |format|
      format.html { redirect_to(theaters_url) }
      format.xml  { head :ok }
    end
  end
end
