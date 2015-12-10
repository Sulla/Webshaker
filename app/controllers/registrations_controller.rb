# coding: utf-8

class RegistrationsController < Devise::RegistrationsController
  protected

  def after_sign_up_path_for(resource)
    'http://vps.webinti.com/webshaker/welcome'
  end
end