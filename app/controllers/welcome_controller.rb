class WelcomeController < ApplicationController
  
  def index
  end
  
  def registrarse
    @recipient = Recipient.new
  end
  
  def registrarse_post
    @recipient = Recipient.new params[:recipient]
    
    if @recipient.valid?
      Notifier.subscription(@recipient).deliver
      
      render 'registrado'
    else
      render 'registrarse'
    end
        
  end
end
