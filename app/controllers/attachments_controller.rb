# coding: utf-8

require 'iconv'

class AttachmentsController < ApplicationController
  
  before_filter :authenticate_user!
  
  def create
    # passenger bug
    
    request.env['rack.input'].read(1)
    request.env['rack.input'].rewind
    
    @filename = 'public/system/' + params['qqfile']
    @filename = clean_filename(@filename)
    
    newf = File.open(@filename, "wb")
    str =  request.body.read
    newf.write(str)
    newf.close
    
    file       = File.open(@filename)#request.headers['rack.input']
    attachment = Attachment.create(:picture => file, :user_id => current_user.id, :post_id => params[:post_id])
    
    FileUtils.rm(@filename)
    
    render :json => { :success => true, :picture => attachment }
  end
  
  def destroy
    attachment = Attachment.find(params[:id])
    
    if attachment.user == current_user || current_user.is_admin?
      attachment.destroy
    end
    
    head :ok
    
  end
  
  private
  
  def clean_filename(str)
    # Based on permalink_fu by Rick Olsen

    # Escape str by transliterating to UTF-8 with Iconv
    s = Iconv.iconv('ascii//ignore//translit', 'utf-8', str).to_s

    # Downcase string
    s.downcase!

    # Remove apostrophes so isn't changes to isnt
    s.gsub!(/'/, '')

    # Replace any non-letter or non-number character with a space
    s.gsub!(/[^A-Za-z0-9]+/, ' ')

    # Remove spaces from beginning and end of string
    s.strip!

    # Replace groups of spaces with single hyphen
    s.gsub!(/\ +/, '-')

    return s
  end
  
end