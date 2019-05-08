--[[

Referencia : https://github.com/ChristianoBraga/PiFramework/blob/master/doc/pi-in-a-nutshell.md

Tipos Basicos 

NUM numero 					{"NUM",<numero>}  | Ex: 3  => {"NUM",3}  | Tanto faz o  tipo do 3,int,float,double,, soh algo que  da pra fazer conta
BOO booleanas 				{"BOO", "TRUE"}  OU {"BOO","FALSE"} , usei Strings em vezdesoh  true  e falsee ja tratei, soh pra tipo nao ter erro de tipo dizer que TRUE e FALSE  sao palavras reservada
ID 	Identificador			{"ID",<nomedo id>} | Ex: bola => {"ID","bola"}

Expressoes aritimeticas
		
SUM soma 					{"SUM", <numero A ou expressao A> , <numero B ou expressao B>} 	| Ex :  2 + 4 ==> {"SUM", {"NUM",2} , {"NUM",4}}     
SUB subtracao				{"SUB", <numero A ou expressao A> , <numero B ou expressao B>}	| Ex :  4 - 1 ==> {"SUB", {"NUM",4} , {"NUM",1}}  
MUL multiplicacao			{"MUL", <numero A ou expressao A> , <numero B ou expressao B>}	| Ex :  9 * 7 ==> {"MUL", {"NUM",9} , {"NUM",7}}  
DIV divisao					{"DIV", <numero A ou expressao A> , <numero B ou expressao B>}	| Ex :  3 / 6 ==> {"DIV", {"NUM",3} , {"NUM",6}}  
EQ  igual					{"EQ", <numero A ou expressao A> , <numero B ou expressao B>}	| Nesse e nos 4 abaixo nao estamos tratando caso  nao seja um numero,o prof falo disso de tipo tratar pra nao deixar entrar aqui
LT  menor que 				{"LT", <numero A ou expressao A> , <numero B ou expressao B>}	| e deixar rolar sabe ? Por enquanto nao ligarmos pra qual "tipo" de info ele quer comparar
LE	menor ou igual			{"LE", <numero A ou expressao A> , <numero B ou expressao B>}	| 
GT 	maior que 				{"GT", <numero A ou expressao A> , <numero B ou expressao B>}	|
GE  maior ou igual 			{"GE", <numero A ou expressao A> , <numero B ou expressao B>}	|

Expressoes booleanas 

AND e 						{"AND", <boolean A ou expressaoBooleana A>, <boolean B ou expressaoBooleana B>} | Ex : TRUE AND 2 > 3  ==> {"AND",{"BOO","TRUE"},{"GT",{"NUM",2},{"NUM",3}}}
OR  ou 						{"OR", <boolean A ou expressaoBooleana A>, <boolean B ou expressaoBooleana B>} 	|
NOT nao 					{"NOT", <boolean A ou expressaoBooleana A>} | Ex: NOT 5 <= 6    ==>  {"NOT", {"LE",5,6}} | acho que tanto faz ficar NOT(5<=6) ou NOT 5<=6, vamos fazer sem parentezes mesmo,mas tanto faz devolve a mesma coisa
 
Comandos

LOOP 						{"LOOP",<expressaoBooleana>,<expressaoBooleana ou aritmetica ou comando>} |Ex: LOOP TRUE 1 + 1 ==> {"LOOP",{"BOO","TRUE"}, {"SUM", 1 , 1} } | EXMaisDificil: LOOP bola > 4 bola + 1  ou LOOP (bola > 4) bola + 1  ==> {"LOOP", {"GT" , {"ID", "bola"} , {"NUM", 4} } , {"SUM", {"ID","bola"}, {"NUM", 1} } } 
COND  						{"COND",<expressaoBooleana>,<expressaoBooleana ou aritmetica ou comando A> , <expressaoBooleana ou aritmetica ou comando B>} | Ex: COND 0 < 1 5+7 3*4 ==> << 0<1=Exp  5+7=A, 3*4=B >>  {"COND", {Exp} , {A} , {B}}
ASSING 						{"ASSING",<ID>,<expressaoAritmetica ou Booleana ou Num ou Boo>} | Ex: bola = 3  ou bola := 3   (como preferir, da no mesmo pro meu lado)  ==> {"ASSING", {"ID", "bola"}, {"NUM",3} } 

]]


function tLen(T) --Prasaber o tamanho da tabela | serio nao use  # nao eh deterministico
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end

function pop(pile)
	if pile ~= {} then
		lastIndex = tLen(pile)
		value = pile[lastIndex]
		table.remove(pile,lastIndex)
		return value
	end
end

function push(pile,item)
	table.insert(pile,item) --como nao tem valor coloca no final
end

function getLocalization(env,stor) --por enquanto sempre coloca no final do stor 
	return tLen(stor)
end

function getValue(item) --NUM,BOO,ID,LOC
	category = item[1]
	value = item[2]
	if category == "NUM" then
		return value
	elseif category == "BOO" then
		if value == "TRUE" then
			return true
		elseif value == "FALSE" then
			return false
		else
			print("Erro em valor de Booleana")
		end
	elseif category == "ID" then
		return value
	elseif category == "LOC" then
		return value	 	
	end

end

function getFirst(item) --{"Category",value1,value2,value3}
	return item[2]

end

function getSecond(item)
	return item[2]
end

function getThird(item)
	return item[3]
end

function makeNode(value,category)
	node = {category,value}
	return node
end

function handle_NUM(item,cPile,vPile,env,stor)
	push(vPile,item)
	automaton.rec(cPile,vPile,env,stor,result)
end

function handle_SUM(item,cPile,vPile,env,stor)
	OP = {"#SUM"}
	valueA = getFirst(item)
	valueB = getSecond(item)
	push(cPile,OP)
	push(cPile,valueA)
	push(cPile,valueB)
	automaton.rec(cPile,vPile,env,stor,result)
end

function handle_H_SUM(item,cPile,vPile,env,stor)--#SUM , soma dos dois primeiros itens em vPile
	valueA = getValue(pop(vPile))
	valueB = getValue(pop(vPile))
	result = valueA + valueB
	push(vPile,makeNode(result,"NUM"))
	automaton.rec(cPile,vPile,env,stor,result)
end

function handle_SUB(item,cPile,vPile,env,stor)
	OP = {"#SUB"}
	valueA = getFirst(item)
	valueB = getSecond(item)
	push(cPile,OP)
	push(cPile,valueA)
	push(cPile,valueB)
	automaton.rec(cPile,vPile,env,stor,result)
end

function handle_H_SUB(item,cPile,vPile,env,stor)
	valueA = getValue(pop(vPile))
	valueB = getValue(pop(vPile))
	result = valueA - valueB
	push(vPile,makeNode(result,"NUM"))
	automaton.rec(cPile,vPile,env,stor,result)
end

function handle_MUL(item,cPile,vPile,env,stor)
	OP = {"#MUL"}
	valueA = getFirst(item)
	valueB = getSecond(item)
	push(cPile,OP)
	push(cPile,valueA)
	push(cPile,valueB)
	automaton.rec(cPile,vPile,env,stor,result)
end

function handle_H_MUL(item,cPile,vPile,env,stor)
	valueA = getValue(pop(vPile))
	valueB = getValue(pop(vPile))
	result = valueA * valueB
	push(vPile,makeNode(result,"NUM"))
	automaton.rec(cPile,vPile,env,stor,result)
end

function handle_DIV(item,cPile,vPile,env,stor)
	OP = {"#DIV"}
	valueA = getFirst(item)
	valueB = getSecond(item)
	push(cPile,OP)
	push(cPile,valueA)
	push(cPile,valueB)
	automaton.rec(cPile,vPile,env,stor,result)
end

function handle_H_DIV(item,cPile,vPile,env,stor)
	valueA = getValue(pop(vPile))
	valueB = getValue(pop(vPile))
	result = valueA / valueB
	push(vPile,makeNode(result,"NUM"))
	automaton.rec(cPile,vPile,env,stor,result)
end

function handle_EQ(item,cPile,vPile,env,stor)
	OP = {"#EQ"}
	valueA = getFirst(item)
	valueB = getSecond(item)
	push(cPile,OP)
	push(cPile,valueA)
	push(cPile,valueB)
	automaton.rec(cPile,vPile,env,stor,result)
end

function handle_H_EQ(item,cPile,vPile,env,stor)
	valueA = getValue(pop(vPile))
	valueB = getValue(pop(vPile))
	if valueA == valueB then 
		result = "TRUE"
	else
		result = "FALSE"
	end
	push(vPile,makeNode(result,"BOO"))
	automaton.rec(cPile,vPile,env,stor,result)
end

function handle_LT(item,cPile,vPile,env,stor)
	OP = {"#LT"}
	valueA = getFirst(item)
	valueB = getSecond(item)
	push(cPile,OP)
	push(cPile,valueA)
	push(cPile,valueB)
	automaton.rec(cPile,vPile,env,stor,result)
end

function handle_H_LT(item,cPile,vPile,env,stor)
	valueA = getValue(pop(vPile))
	valueB = getValue(pop(vPile))
	if valueA < valueB then 
		result = "TRUE"
	else
		result = "FALSE"
	end
	push(vPile,makeNode(result,"BOO"))
	automaton.rec(cPile,vPile,env,stor,result)
end

function handle_LE(item,cPile,vPile,env,stor)
	OP = {"#LE"}
	valueA = getFirst(item)
	valueB = getSecond(item)
	push(cPile,OP)
	push(cPile,valueA)
	push(cPile,valueB)
	automaton.rec(cPile,vPile,env,stor,result)
end

function handle_H_LE(item,cPile,vPile,env,stor)
	valueA = getValue(pop(vPile))
	valueB = getValue(pop(vPile))
	if valueA <= valueB then 
		result = "TRUE"
	else
		result = "FALSE"
	end
	push(vPile,makeNode(result,"BOO"))
	automaton.rec(cPile,vPile,env,stor,result)
end

function handle_GT(item,cPile,vPile,env,stor)
	OP = {"#GT"}
	valueA = getFirst(item)
	valueB = getSecond(item)
	push(cPile,OP)
	push(cPile,valueA)
	push(cPile,valueB)
	automaton.rec(cPile,vPile,env,stor,result)
end

function handle_H_GT(item,cPile,vPile,env,stor)
	valueA = getValue(pop(vPile))
	valueB = getValue(pop(vPile))
	if valueA > valueB then 
		result = "TRUE"
	else
		result = "FALSE"
	end
	push(vPile,makeNode(result,"BOO"))
	automaton.rec(cPile,vPile,env,stor,result)
end

function handle_GE(item,cPile,vPile,env,stor)
	OP = {"#GE"}
	valueA = getFirst(item)
	valueB = getSecond(item)
	push(cPile,OP)
	push(cPile,valueA)
	push(cPile,valueB)
	automaton.rec(cPile,vPile,env,stor,result)
end

function handle_H_GE(item,cPile,vPile,env,stor)
	valueA = getValue(pop(vPile))
	valueB = getValue(pop(vPile))
	if valueA >= valueB then 
		result = "TRUE"
	else
		result = "FALSE"
	end
	push(vPile,makeNode(result,"BOO"))
	automaton.rec(cPile,vPile,env,stor,result)
end

function handle_BOO(item,cPile,vPile,env,stor)
	push(vPile,item)
	automaton.rec(cPile,vPile,env,stor,result)
end

function handle_AND(item,cPile,vPile,env,stor)
	OP = {"#AND"}
	valueA = getFirst(item)
	valueB = getSecond(item)
	push(cPile,OP)
	push(cPile,valueA)
	push(cPile,valueB)
	automaton.rec(cPile,vPile,env,stor,result)
end

function handle_H_AND(item,cPile,vPile,env,stor)
	valueA = getValue(pop(vPile))
	valueB = getValue(pop(vPile))
	if valueA and valueB then
		result="TRUE"
	else
		result="FALSE"
	end
	push(vPile,makeNode(result,"BOO"))
	automaton.rec(cPile,vPile,env,stor,result)
end


function handle_OR(item,cPile,vPile,env,stor)
	OP = {"#OR"}
	valueA = getFirst(item)
	valueB = getSecond(item)
	push(cPile,OP)
	push(cPile,valueA)
	push(cPile,valueB)
	automaton.rec(cPile,vPile,env,stor,result)
end

function handle_H_OR(item,cPile,vPile,env,stor)
	valueA = getValue(pop(vPile))
	valueB = getValue(pop(vPile))
	if valueA or valueB then
		result="TRUE"
	else
		result="FALSE"
	end
	push(vPile,makeNode(result,"BOO"))
	automaton.rec(cPile,vPile,env,stor,result)
end

function handle_NOT(item,cPile,vPile,env,stor)
	OP = {"#NOT"}
	valueA = getFirst(item)
	push(cPile,OP)
	push(cPile,valueA)
	automaton.rec(cPile,vPile,env,stor,result)
end

function handle_H_NOT(item,cPile,vPile,env,stor)
	value = getValue(pop(vPile)) --nesse caso apenas um valor
	if value then
		result="FALSE"
	else
		result="TRUE"
	end
	push(vPile,makeNode(result,"BOO"))
	automaton.rec(cPile,vPile,env,stor,result)
end


function handle_LOOP(item,cPile,vPile,env,stor)
	OP={"#LOOP"}
	booExp= getFirst(item)

	push(vPile,item) 		--vai no vPile mesmo

	push(cPile,OP)
	push(cPile,booExp)
	automaton.rec(cPile,vPile,env,stor,result)

end

function handle_H_LOOP(item,cPile,vPile,env,stor)
	booValue= getValue(pop(vPile))
	loop = pop(vPile)
	if booValue then
		command = getSecond(loop)
		push(cPile,loop)
		push(cPile,command)
	end
end

function handle_COND(item,cPile,vPile,env,stor)
	OP={"#COND"}
	booExp= getFirst(item)

	push(vPile,item) 

	push(cPile,OP)
	push(cPile,booExp)

	automaton.rec(cPile,vPile,env,stor,result)
end

function handle_H_COND(item,cPile,vPile,env,stor)
	booValue= getValue(pop(vPile))
	cond = pop(vPile)
	if booValue then --Pega o comando 1 ou o 2 
		command = getSecond(loop)
		push(cPile,command)
	else
		command = getThird(loop)
		push(cPile,command)
	end
end

function handle_ID(item,cPile,vPile,env,stor)
	idValue = getValue(item)
	itemLoc = getValue(env[idValue])
	itemBindded = stor[itemLoc] 
	push(vPile,itemBindded)
	automaton.rec(cPile,vPile,env,stor,result)
end

function handle_ASSING(item,cPile,vPile,env,stor)
	OP = {"#ASSING"}
	id = getFirst(item)
	exp = getSecond(item)

	push(vPile,id)

	push(cPile,OP) 		
	push(cPile,exp)

	automaton.rec(cPile,vPile,env,stor,result)
end

function handle_H_ASSING(item,cPile,vPile,env,stor)
	expValue = pop(vPile) 
	idValue = getValue(pop(vPile))
	loc = getLocalization() 
	env[idValue] = loc 
	stor[loc] = expValue
	automaton.rec(cPile,vPile,env,stor,result)
end

function handle_CSEQ(item,cPile,vPile,env,stor)
	command1 = getFirst(item)
	command2 = getSecond(item)
	push(cPile,command2)
	push(cPile,command1)
	automaton.rec(cPile,vPile,env,stor,result)
end

--[[
Obs1: Ver expressoes que ordem queremos ValueA e ValueB  ou B A na pilha

Obs2: Ver se ja colocamos os valores em si na pilha de valores ou deixamos  encapsulado pelo NUMB, BOO e ID 
(considerando que talvez o BOO tenha qeu se manter no BOO(true) e BOO(false) ,para nao acharem que eh ID) 


Obs3: Colocar os valores em env com o tipo LOCATION (LOC)
 
]]

handlers =
    {
        ["NUM"]=handle_NUM,
		["BOO"]=handle_BOO,
		["ID"]=handle_ID,
        ["SUM"]=handle_SUM,
        ["#SUM"]=handle_H_SUM,
        ["SUB"]=handle_SUB,
        ["#SUB"]=handle_H_SUB,
        ["MUL"]=handle_MUL,
        ["#MUL"]=handle_H_MUL,
        ["DIV"]=handle_DIV,
        ["#DIV"]=handle_H_DIV,
        ["EQ"]=handle_EQ,
        ["#EQ"]=handle_H_EQ,
        ["LT"]=handle_LT,
        ["#LT"]=handle_H_LT,
        ["LE"]=handle_LE,
        ["#LE"]=handle_H_LE,
        ["GT"]=handle_GT,
        ["#GT"]=handle_H_GT,
        ["GE"]=handle_GE,
        ["#GE"]=handle_H_GE,
        ["AND"]=handle_AND,
        ["#AND"]=handle_H_AND,
        ["OR"]=handle_OR,
        ["#OR"]=handle_H_OR,
        ["NOT"]=handle_NOT,
        ["#NOT"]=handle_H_NOT,
        ["LOOP"]=handle_LOOP,
        ["#LOOP"]=handle_H_LOOP,
        ["COND"]=handle_COND,
        ["#COND"]=handle_H_COND,
        ["ASSING"]=handle_ASSING,
        ["#ASSING"]=handle_H_ASSING,
        ["CSEQ"]=handle_CSEQ
    }

--Funcao recursiva simples que apenas ve o que eh pedido e envia para outra funcao
function automaton.rec(cPile,vPile,env,stor,result)
	if cPile ~= {} then
		return result
	end

	item = pop(cPile)

	stat=getStatement(item) --stat para statement, pois pode  ser operacao ou comando

	handlers[stat](item,cPile,vPile,env,stor)

end

function automaton.auto(tree)

	cPile={} --control pile
	vPile={} --value pile
	env={} 	 --enviroment
	sto={}   --storage

	result=0 --apenas iniciando variavel de retorno final

	push(cPile,tree)

	result = automaton.rec(cPile,vPile,env,stor,result)
	resp = getValue(result)
end

