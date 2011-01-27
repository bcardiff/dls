class Notifier < ActionMailer::Base
  default :from => "Distribuidora La Salada <no-reply@distrilasalada.com.ar>"
  
  def purchase_to_merchant(recipient, products)
    @recipient = recipient
    @products = products

    mail(:to => "pedidos@distrilasalada.com.ar",
             :subject => "Pedido de #{recipient.name}")
  end
  
  def purchase_to_buyer(recipient, products)
    @recipient = recipient
    @products = products
    
    mail(:to => recipient.email,
             :subject => "Copia de su pedido")
  end
  
  def subscription(recipient)
    @recipient = recipient
    
    mail(:to => "registro@distrilasalada.com.ar",
            :subject => "Registro en mailing")
  end
end
