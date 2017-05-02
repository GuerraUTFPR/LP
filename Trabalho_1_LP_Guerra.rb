#=========== class sala ==============
class Sala
	def initialize(descricao,opcao)  					
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
		
		end
		puts "O que deseja fazer?"
		for @i in (0..@aux)			
			print @opc[@i].print_comando
		end

		print "Digite uma opção: "
		@valor = gets
		
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
		@tam = @data_hash.size - 1
		arq = File.new("graphviz.txt", "w")
		arq.puts ("digraph g {\ngraph [\nrankdir = \"LR\"\n];\nnode [\nfontsize = \"16\"\nshape = \"ellipse\"\n];\nedge [\n];\n")

		for i in (0..@tam)
			arq.puts("\"node#{i}\" [\n")
			arq.print ("label = \"")
			arq.print ("<f#{0}> #{@data_hash[i]["nome"]} |")
			for j in (0..data_hash[i]["opcao"].size - 1)				
				arq.print("<f#{j+1}> #{@data_hash[i]["opcao"][j]["comando"]} ")
				if j < data_hash[i]["opcao"].size - 1
					arq.print ("|")
				end 
			end
				arq.print("\"\nshape = \"record\"\n];\n")
		end

		count = 0

		for i in (0..@tam)			
			for j in (0..data_hash[i]["opcao"].size - 1)
				if @data_hash[i]["opcao"][j]["chave"] != "nenhum"
					arq.print("\"node#{i}\": ")
					k = get_index_next(@data_hash[i]["opcao"][j]["chave"], @data_hash)
					arq.print("f#{j+1} -> \"node#{k}\":f0 [\n")
					arq.print("id = #{count}\n];\n")
					count = count + 1
				end
			end
		end
		arq.print("}")

	end

	def get_index_next(key, data_hash)
		@key = key
		@data_hash = data_hash
		@tam = @data_hash.size - 1


		for i in (0..@tam)
			if key == data_hash[i]["nome"]
				return i
			end
		end
	end
end

#=========== main ========================

salas = Hash.new
ctrl = Control.new
Process.spawn("mocp -o Repeat 0.mp3")
Process.spawn("mocp -l 0.mp3")



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

key = data_hash[0]["nome"]


while key != "final"
	key = ctrl.imprime_sala(salas, key)
end

ctrl.generate_dot(data_hash)
Process.spawn("mocp -s")