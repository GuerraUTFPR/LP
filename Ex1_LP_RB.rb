class Product
	@@numberOfProducts = 0
	def initialize (id, name, brand, price, tax, perishable)
		@id = id
		@name = name
		@brand = brand
		@price = price
		@tax = tax
		@perishable = perishable
		@@numberOfProducts += 1
	end	

	def display()
		puts "ID:#@id Nome:#@name Marca:#@brand Preço:#@price Imposto:#@tax Perecivel:#@perishable"
	end

	def getFinalPrice()
		finalPrice = 0
		finalPrice = @price + (@price * @tax)
		puts "Preço Final:#{finalPrice}"
	end

	def numberOfProd()
		puts "Qtd de produtos:#{@@numberOfProducts}"
	end
end

#Criando Objetos
prod1 = Product.new(1, "Refrigerante", "coca cola", 4.50, 0.15, true)
prod2 = Product.new(2, "Macarrão", "nissin", 0.9, 0.15, false)
prod3 = Product.new(3, "carne bovina", "friboi", 15.47, 2.0, true)
prod4 = Product.new(4, "Oléo", "Coamo", 1.5, 3.5, false)
prod5 = Product.new(5, "leite", "piracanjuba", 2.25, 0.55, false)
prod6 = Product.new(6, "bolacha", "trakinas", 1.78, 1.0, true)
prod7 = Product.new(7, "cerveja", "budwiser", 4.50, 1.15, true)

arrayprod = [prod1, prod2, prod3, prod4, prod5, prod6, prod7]

arrayprod.each do |prod|
	prod.display()
	prod.getFinalPrice()
	puts"\n"
end

prod1.numberOfProd()