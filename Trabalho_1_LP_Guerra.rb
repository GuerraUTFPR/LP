#=========== class sala ==============
class Sala
	def initialize(descricao,opcao)  						#construtor obj Sala
		@descricao = descricao
		@opcao = opcao
		@visitado = false
	end	

	def imprime_descricao
		puts("#{@descricao}")		
	end

	def get_opc_size
		return @opcao.size-1		
	end

	def get_opc	
		return @opcao		
	end

	def set_visitado(visitado)
		@visitado = visitado
	end	
	def get_visitado
		return @visitado
	end
end	

#=========== class comando ===========

class Comando	
	def initialize(comando, resultado, chave = "nenhum")
		@comando = comando
		@resultado = resultado
		@chave = chave
	end

	def print_comando
		puts("#{@comando}")		
	end

	def print_resultado
		puts("\n#{@resultado}\n\n")				
	end

	def get_chave
		return @chave		
	end
end	

#=========== class control ===========

class Control	
	def imprime_sala(salas,key)
		@salas = salas
		@key = key
		@atual = @salas[key]		
		@aux = @atual.get_opc_size		
		@opc = @atual.get_opc	
		
		if @atual.get_visitado == false
			puts @atual.imprime_descricao
			@atual.set_visitado(true)
		else
			puts "Tente outra opção :)\n"
		end
		puts "O que deseja fazer?"
		for @i in (0..@aux)			
			print @opc[@i].print_comando
		end

		print "Digite uma opção: "
		@valor = gets
		#print "\nvocê escolhe a opcão #{@valor}"

		@opc[@valor.to_i - 1].print_resultado
		@x = @opc[@valor.to_i - 1].get_chave
		

		if @x == "nenhum"		
			return @key
		else
			return @x
		end
	end

	def generate_dot(data_hash)
		@data_hash = data_hash
		arq = File.new("graphviz.txt", "w")
		arq.puts ("digraph g {\ngraph [\nrankdir = \"LR\"\n];\nnode [\nfontsize = \"16\"\nshape = \"ellipse\"\n];\nedge [\n];")

	end
end

#=========== main ========================

salas = Hash.new
ctrl = Control.new
Process.spawn("mocp -o Repeat 0.mp3")
Process.spawn("mocp -l 0.mp3") #mocp -l passar arquivo para tocar



require 'json'
file = File.read("teste.json")
data_hash = JSON.parse(file)
tam = data_hash.size - 1


for j in (0..tam)
	descricao = data_hash[j]["descricao"]
	arr = Array.new
	for i in (0..data_hash[j]["opcao"].size-1)		
		comando = data_hash[j]["opcao"][i]["comando"]
		resultado = data_hash[j]["opcao"][i]["resultado"]
		chave = data_hash[j]["opcao"][i]["chave"]		
		cmd = Comando.new(comando, resultado, chave)	
		arr << cmd
	end
	room = Sala.new(descricao,arr)	
	salas.store(data_hash[j]["nome"], room)
	
end
	#puts "#{arr}"

#puts salas["sala_1"].get_opc[2].print_comando



key = data_hash[0]["nome"]

for k in (0..2)	#while != end
	key = ctrl.imprime_sala(salas, key)

end

ctrl.generate_dot(data_hash)
Process.spawn("mocp -s")