class Notifier < ActionMailer::Base
  default :from => "Distribuidora La Salada <no-reply@distrilasalada.com.ar>"
  
  def purchase_to_merchant(recipient, products, total)
    @recipient = recipient
    @products = products
    @total = total
    
    mail(:to => Distrilasalada::Application.config.merchant_email,
             :subject => "Pedido de #{recipient.name}")
  end
  
  def purchase_to_buyer(recipient, products, total)
    @recipient = recipient
    @products = products
    @total = total
    
    mail(:to => recipient.email,
             :subject => "Copia de su pedido")
  end
  
  def subscription(recipient)
    @recipient = recipient
    
    mail(:to => Distrilasalada::Application.config.subscription_email,
            :subject => "Registro en mailing")
  end
end
