:- encoding(utf8).

%% ==========================================================================
%% Lista de Exercícios de Prolog - Parte 2 (exercícios 16 a 35)
%% ==========================================================================
%
% Continuação da lista 1 a 15: 5 exercícios fáceis (16 a 20), 10 médios (21 a
% 30) e 5 difíceis (31 a 35). Cada exercício traz o enunciado e um comentário
% com a ideia e o raciocínio da questão. O GABARITO está no final do arquivo,
% todo comentado: tente resolver antes de lê-lo e, para executá-lo, remova o
% "% " do início das linhas de código.
%
% Convenções: identificadores sem acentos; os exercícios 28 e 29 usam anexa/3
% (exercício 12); numlist/3, permutation/2, select/3, memberchk/2 e sum_list/2
% são da biblioteca padrão do SWI-Prolog. As bases de fatos dos exercícios 16
% e 30 já estão carregadas neste arquivo; nos demais, escreva os predicados
% pedidos abaixo do enunciado ou em outro arquivo.
%
% Os programas do gabarito foram executados em SWI-Prolog (compilado para
% WebAssembly) e as respostas indicadas foram conferidas.

:- dynamic fib_memo/2.

%% --------------------------------------------------------------------------
%% 16) Animais: fatos e regras  [FÁCIL]
%% --------------------------------------------------------------------------
% Considere a base de fatos a seguir, no formato animal(Nome, Classe, Dieta):
%  a) Defina a regra come_carne(X), verdadeira para animais carnívoros ou
%     onívoros.
%  b) Defina mesma_classe(X,Y), verdadeira quando X e Y são animais distintos
%     da mesma classe.
%  c) Consulte: quais aves comem carne? Quais mamíferos são herbívoros? Quais
%     são todos os pares de animais da mesma classe?
%
% Comentário: Revisa fatos, regras e consultas com variáveis. Duas cláusulas
% para o mesmo predicado expressam "ou"; a vírgula dentro de uma cláusula
% expressa "e". Em (b), a meta X \= Y deve vir depois das metas que instanciam
% X e Y: com variáveis livres, X \= Y sempre falha, porque duas variáveis
% livres unificam. É o mesmo efeito de ordem de metas discutido no exercício
% 5.

animal(leao, mamifero, carnivoro).
animal(vaca, mamifero, herbivoro).
animal(aguia, ave, carnivoro).
animal(pardal, ave, onivoro).
animal(sapo, anfibio, carnivoro).
animal(coelho, mamifero, herbivoro).

come_carne(X) :- animal(X, _, Y), (Y == carnivoro ; Y == onivoro).
mesma_classe(X, Y) :- animal(X, A, _), animal(Y, B, _), dif(X, Y), A == B.

% ?- animal(X, ave, _), come_carne(X).
% ?- animal(X, mamifero, _), \+ come_carne(X).
% ?- mesma_classe(X, Y).

%% --------------------------------------------------------------------------
%% 17) Aritmética básica  [FÁCIL]
%% --------------------------------------------------------------------------
%  a) Defina maior(X,Y,M), em que M é o maior entre os números X e Y.
%  b) Defina par(N) e impar(N) usando o operador mod.
%  c) Execute e explique a diferença entre as consultas ?- X = 2+3., ?- X is
%     2+3. e ?- 2+3 =:= 5.
%
% Comentário: Em Prolog, = apenas unifica estruturas: X = 2+3 liga X ao termo
% 2+3, sem calcular. is avalia o lado direito (que deve estar totalmente
% instanciado) e unifica o resultado com o lado esquerdo. =:= compara os
% valores de duas expressões aritméticas. Em (a), as duas cláusulas devem ter
% guardas mutuamente exclusivas (>= e <); sem isso, X = Y produziria duas
% respostas iguais. Em impar/1, a comparação com 1 funciona também para
% negativos, pois em SWI-Prolog o resultado de mod tem o sinal do divisor (-3
% mod 2 = 1).

maior(X,Y,M) :- (X > Y -> M = X ; M = Y).
par(N) :- N mod 2 =:= 0.
impar(N) :- N mod 2 =:= 1.

%% --------------------------------------------------------------------------
%% 18) Pertinência em lista  [FÁCIL]
%% --------------------------------------------------------------------------
%  a) Defina pertence(X,L), verdadeira se X é elemento da lista L.
%  b) Consulte pertence(b,[a,b,c]), pertence(d,[a,b,c]) e pertence(X,[a,b,c]).
%     O que a terceira consulta faz?
%  c) Compare o comportamento do seu predicado com o predicado nativo
%     member/2.
%
% Comentário: Primeira recursão sobre listas: uma cláusula para quando X é a
% cabeça ([X|_]) e outra que descarta a cabeça e continua na cauda. Não há
% cláusula para a lista vazia; a falha dessa busca é o que torna falsa a
% consulta com elemento ausente (pressuposto de mundo fechado). O mesmo
% predicado serve para testar (X conhecido) e para gerar (X livre, enumerando
% os elementos), característica central da programação relacional.

% Minha solução, mas não funciona para consulta com variável livre
% pertence(_, []) :- fail.
% pertence(X, [Y|Ys]) :- X == Y ; pertence(X, Ys).
pertence(X, [X|_]).
pertence(X, [_|T]) :- pertence(X, T).

%% --------------------------------------------------------------------------
%% 19) Tamanho de uma lista  [FÁCIL]
%% --------------------------------------------------------------------------
%  a) Defina tamanho(L,N), em que N é o número de elementos de L, sem usar
%     length/2.
%  b) Consulte tamanho([a,b,c,d],N).
%  c) Consulte tamanho(L,2). Qual é a primeira resposta? O que acontece se
%     você pedir outra resposta com ;? Explique.
%
% Comentário: Raciocínio indutivo: a lista vazia tem tamanho 0; uma lista
% [_|T] tem o tamanho de T mais 1. A chamada recursiva vem antes do is, pois o
% is precisa do valor de M já calculado. Em (c), com L livre o predicado gera
% listas de tamanho crescente (0, 1, 2, ...). A primeira resposta, L = [_, _],
% está correta, mas ao pedir mais respostas o sistema continua gerando listas
% maiores que nunca terão tamanho 2, e a busca não termina.

%% --------------------------------------------------------------------------
%% 20) Dobro dos elementos  [FÁCIL]
%% --------------------------------------------------------------------------
%  a) Defina dobros(L,R), em que R contém o dobro de cada elemento de L, na
%     mesma ordem.
%  b) Consulte dobros([1,2,3],R).
%  c) Consulte dobros(L,[2,4]). Por que ocorre um erro? Como o predicado teria
%     que ser escrito para funcionar nesse sentido?
%
% Comentário: Mostra como construir uma lista de saída: o elemento calculado e
% a lista restante aparecem na cabeça da cláusula, [Y|R], e a recursão
% preenche R. Em (c) o erro (instanciação) acontece porque is exige o lado
% direito instanciado: com X livre, 2*X não pode ser avaliado. Aritmética com
% is não é reversível; para funcionar nos dois sentidos seria preciso
% restrições aritméticas (biblioteca clpfd) ou uma segunda definição que
% divida por 2.

%% --------------------------------------------------------------------------
%% 21) Fatorial: recursão e acumulador  [MÉDIO]
%% --------------------------------------------------------------------------
%  a) Defina fat(N,F) por recursão simples.
%  b) Defina fat_ac(N,F) usando um acumulador (predicado auxiliar fat_ac/3).
%  c) Remova a guarda N > 0 da sua definição de (a). Consulte fat(3,F) e peça
%     outra resposta com ;. O que ocorre e por quê?
%
% Comentário: Na versão simples, o produto é feito depois da chamada
% recursiva, de modo que a pilha cresce com N. Na versão com acumulador, o
% produto é feito antes da chamada, e a última meta da cláusula é a própria
% chamada recursiva (recursão de cauda), o que permite ao sistema reaproveitar
% o quadro de pilha. Em (c), sem a guarda a segunda cláusula também casa com N
% = 0 após a primeira resposta, gerando N = -1, -2, ... indefinidamente. A
% guarda torna as cláusulas mutuamente exclusivas.

%% --------------------------------------------------------------------------
%% 22) Fibonacci e memoização  [MÉDIO]
%% --------------------------------------------------------------------------
%  a) Defina fib(N,F) pela definição recursiva (fib(0)=0, fib(1)=1,
%     fib(N)=fib(N-1)+fib(N-2)).
%  b) Use time(fib(25,F)) e compare com time(fib(30,F)). Explique o
%     crescimento do tempo.
%  c) Defina fibm(N,F) que armazene cada resultado calculado na base de dados
%     com assertz, consultando-a antes de recalcular. Declare o predicado
%     auxiliar como dynamic.
%
% Comentário: A definição direta recalcula os mesmos valores muitas vezes: o
% número de chamadas cresce de forma exponencial em N. Em (c), a memoização
% guarda fib_memo(N,F) como fato: a primeira cláusula devolve o valor já
% armazenado (o corte impede que as demais sejam tentadas), a segunda trata os
% casos base e a terceira calcula e grava. Retoma o uso de assert e retract
% visto nos exercícios 13 a 15. Cuidado: a base mutável persiste entre
% consultas.

%% --------------------------------------------------------------------------
%% 23) Remoção de elementos  [MÉDIO]
%% --------------------------------------------------------------------------
%  a) Defina remove(X,L,R), em que R é L sem uma ocorrência de X. Quantas
%     respostas tem remove(a,[a,b,a,c],R)?
%  b) Defina remove_todas(X,L,R), que remove todas as ocorrências de X.
%  c) Consulte remove(a,L,[b,c]). O que o predicado faz nesse sentido?
%
% Comentário: Em (a), a primeira cláusula remove a cabeça quando ela é X; a
% segunda mantém a cabeça e remove na cauda. Como as duas podem valer, o
% predicado é não determinístico e produz uma resposta por ocorrência (duas no
% exemplo). Em (b), a terceira cláusula precisa da guarda X \= H; sem ela, o
% elemento também seria mantido e o predicado devolveria respostas incorretas.
% Em (c), o predicado trabalha como "inserção": gera todas as listas que, ao
% perder um a, resultam em [b,c].

%% --------------------------------------------------------------------------
%% 24) Eliminação de repetidos  [MÉDIO]
%% --------------------------------------------------------------------------
%  a) Defina sem_repetidos(L,R), em que R tem os elementos de L sem
%     repetições, mantendo a última ocorrência de cada um. Por exemplo,
%     sem_repetidos([a,b,a,c,b],R) resulta em R = [a,c,b].
%  b) Explique o papel do corte na sua solução.
%  c) Reescreva sem corte, usando negação (\+) e memberchk/2. Por que
%     memberchk/2 é mais adequado que pertence/2 nessa versão?
%
% Comentário: A ideia é olhar apenas a cauda: se a cabeça H ainda aparece na
% cauda, ela é descartada (a ocorrência mais à direita será mantida); caso
% contrário, H entra no resultado. O corte confirma a escolha da segunda
% cláusula e impede que a terceira também seja usada para o mesmo elemento. Na
% versão sem corte, as duas condições (memberchk e \+ memberchk) são
% excludentes. memberchk/2 é determinístico; pertence/2 deixaria pontos de
% escolha e geraria respostas duplicadas quando H aparece mais de uma vez.

%% --------------------------------------------------------------------------
%% 25) Intercalação de listas ordenadas  [MÉDIO]
%% --------------------------------------------------------------------------
%  a) Defina intercala(L1,L2,L), em que L1 e L2 estão em ordem crescente e L é
%     a união ordenada dos seus elementos.
%  b) Mostre que findall(R, intercala([1,4,9],[2,3,10,11],R), Rs) produz uma
%     única resposta.
%  c) Por que as cláusulas devem ser escritas de modo que não se sobreponham?
%
% Comentário: Recursão sobre duas listas ao mesmo tempo: compara-se as duas
% cabeças, move-se a menor para o resultado e continua-se com o restante. As
% guardas X =< Y e X > Y são exclusivas. Os casos base também: a segunda
% cláusula só vale para primeira lista não vazia, de modo que
% intercala([],[],L) não gera resposta duplicada. Este predicado é a etapa de
% combinação do merge sort.

%% --------------------------------------------------------------------------
%% 26) Ordenação por inserção  [MÉDIO]
%% --------------------------------------------------------------------------
%  a) Defina insere(X,L,R), que insere X na lista ordenada L, mantendo-a
%     ordenada.
%  b) Defina ordena(L,S), que ordena L usando insere/3.
%  c) Qual é o número de comparações no pior caso, em função do tamanho da
%     lista? Que entrada leva a esse pior caso?
%
% Comentário: Indução sobre a lista: ordena-se a cauda e insere-se a cabeça na
% posição correta. insere/3 percorre a lista ordenada até achar o ponto onde X
% deixa de ser maior que o elemento atual. Elementos repetidos são
% preservados, pois a guarda usa =<. No pior caso (lista em ordem decrescente)
% cada inserção percorre toda a lista parcial: O(n^2) comparações.

%% --------------------------------------------------------------------------
%% 27) Torres de Hanói  [MÉDIO]
%% --------------------------------------------------------------------------
%  a) Defina hanoi(N,Origem,Destino,Auxiliar), que imprima os movimentos
%     necessários para mover N discos de Origem para Destino.
%  b) Defina movimentos(N,M), que calcula o número de movimentos, sem imprimir
%     nada. Mostre que M = 2^N - 1.
%  c) Quantos movimentos são necessários para N = 10?
%
% Comentário: Para mover N discos: (1) mova N-1 discos de Origem para
% Auxiliar, usando Destino como apoio; (2) mova o maior disco para Destino;
% (3) mova os N-1 discos de Auxiliar para Destino, usando Origem como apoio. O
% caso base é N = 0 (nada a fazer). A recorrência M(N) = 2*M(N-1) + 1, com
% M(0) = 0, tem solução 2^N - 1, que se prova por indução.

%% --------------------------------------------------------------------------
%% 28) Árvore binária de busca  [MÉDIO]
%% --------------------------------------------------------------------------
% Represente a árvore vazia por nil e um nó por arv(Esq, Raiz, Dir).
%  a) Defina insere_arv(X,A,NovaA), que insere X na árvore de busca A (valores
%     repetidos são ignorados).
%  b) Defina busca_arv(X,A), verdadeira se X está em A.
%  c) Defina em_ordem(A,L), que devolve os elementos de A em ordem crescente
%     (use anexa/3, exercício 12).
%  d) Defina constroi(L,A), que insere os elementos de L numa árvore
%     inicialmente vazia. Use-o com em_ordem/2 para ordenar uma lista e
%     desenhe a árvore obtida para [5,3,8,1,4].
%
% Comentário: Mostra a recursão sobre estruturas compostas, não apenas listas.
% O invariante é: valores menores à esquerda da raiz, maiores à direita. O
% percurso em ordem (esquerda, raiz, direita) visita os valores em ordem
% crescente. Em (d), como constroi/2 insere de trás para frente, a raiz da
% árvore de [5,3,8,1,4] é 4, o último elemento.

%% --------------------------------------------------------------------------
%% 29) Prefixo, sufixo e sublista  [MÉDIO]
%% --------------------------------------------------------------------------
%  a) Defina prefixo(P,L) e sufixo(S,L) usando apenas anexa/3 (exercício 12),
%     cada um com uma única meta.
%  b) Defina sublista(S,L), verdadeira se S é uma sequência contígua de
%     elementos de L.
%  c) Quantas respostas tem sublista(S,[a,b])? Por que há respostas repetidas
%     e quais são elas?
%
% Comentário: Usa anexa/3 no modo de decomposição: L é conhecida e as partes
% são variáveis. Um prefixo P satisfaz L = P ++ _; um sufixo S satisfaz L = _
% ++ S; uma sublista é um prefixo de algum sufixo. Em (c), a lista vazia é
% prefixo de cada sufixo, então ela aparece uma vez por sufixo (três vezes
% para [a,b]), totalizando seis respostas.

%% --------------------------------------------------------------------------
%% 30) findall, bagof e setof  [MÉDIO]
%% --------------------------------------------------------------------------
% Considere a base emp(Nome, Departamento, Salario):
%  a) Defina bem_pagos(L), com os nomes dos funcionários com salário maior que
%     4000, usando findall/3.
%  b) Defina folha(D,T), com a soma dos salários do departamento D.
%  c) Defina por_depto(D,L), com a lista ordenada dos nomes de cada
%     departamento, usando setof/3 com ^. Consulte com D livre e peça todas as
%     respostas.
%  d) Defina media_depto(D,M), com a média salarial do departamento D, usando
%     bagof/3. Por que setof/3 daria um resultado incorreto para rh?
%
% Comentário: findall/3 reúne todas as soluções e devolve [] se não houver
% nenhuma; bagof/3 e setof/3 falham nesse caso. Variáveis que aparecem na
% meta, mas não no molde, nem após ^, são "livres" e fazem bagof/setof agrupar
% por valor dessas variáveis (comportamento análogo ao GROUP BY de SQL). setof
% ordena e elimina duplicatas; bagof mantém repetidos. Em rh há dois salários
% de 3500, portanto a média correta é 3766,67, e setof (que descarta um 3500)
% daria 3900.

emp(ana, ti, 5000).
emp(bia, ti, 6000).
emp(ivo, rh, 3500).
emp(eva, rh, 3500).
emp(noe, rh, 4300).
emp(leo, vendas, 4500).

%% --------------------------------------------------------------------------
%% 31) Rotas em grafo com ciclos  [DIFÍCIL]
%% --------------------------------------------------------------------------
% O mapa tem as estradas de sentido único listadas a seguir (Origem -> Destino
% : Km) e contém ciclos: a-b-c-a e b-d-e-b.
%
%   a -> b : 5      b -> c : 4      c -> a : 3      c -> d : 7
%   b -> d : 12     d -> e : 2      e -> b : 6
%  a) Codifique o mapa com estrada(Origem,Destino,Km).
%  b) Explique por que a definição transitiva ingênua (rota(A,B) :-
%     estrada(A,B,_). e rota(A,B) :- estrada(A,C,_), rota(C,B).) não termina
%     neste mapa.
%  c) Defina rota(A,B,R,D), com R a lista de cidades e D a distância, sem
%     repetir cidades.
%  d) Defina menor_rota(A,B,R,D), a rota de menor distância. Quais são as
%     rotas de a até e?
%
% Comentário: No exercício 9 o grafo era acíclico, então a recursão sempre
% terminava. Com ciclos é preciso lembrar as cidades já visitadas (lista de
% visitados) e não repeti-las, o que transforma a busca em profundidade num
% procedimento finito. A lista é construída em ordem inversa e revertida no
% final. Para a menor rota, coletam-se todas as rotas como pares Distância-
% Rota com findall/3 e escolhe-se a primeira após keysort/2. Complexidade:
% pode ser exponencial no número de rotas, o que é aceitável para grafos
% pequenos.

%% --------------------------------------------------------------------------
%% 32) N rainhas  [DIFÍCIL]
%% --------------------------------------------------------------------------
% Posicione N rainhas num tabuleiro N x N de modo que nenhuma ataque outra.
% Represente a solução por uma lista Qs, em que o i-ésimo elemento é a linha
% da rainha na coluna i.
%  a) Defina rainhas_gt(N,Qs) pelo método gerar-e-testar: gere uma permutação
%     de 1..N e verifique as diagonais.
%  b) Defina rainhas(N,Qs) com poda: coloque uma rainha por vez e teste cada
%     uma contra as já colocadas.
%  c) Quantas soluções existem para N = 6 e N = 8?
%  d) Compare os tempos (time/1) das duas versões para todas as soluções com N
%     = 8 e N = 9. Explique a diferença.
%
% Comentário: A representação por permutação já garante linhas e colunas
% distintas; resta testar as diagonais: duas rainhas a D colunas de distância
% atacam-se se suas linhas diferem em exatamente D. Na versão (a), as N!
% permutações são geradas por inteiro antes de qualquer teste. Na versão (b),
% a verificação ocorre a cada rainha colocada, descartando prefixos inválidos
% sem expandi-los (poda). Esta é a ideia geral de busca com retrocesso
% (backtracking). Usa predicados da biblioteca de listas do SWI-Prolog:
% numlist/3, permutation/2 e select/3.

%% --------------------------------------------------------------------------
%% 33) Lobo, cabra e repolho  [DIFÍCIL]
%% --------------------------------------------------------------------------
% Um fazendeiro precisa atravessar um rio com um lobo, uma cabra e um repolho,
% num barco que leva apenas ele e mais um item. Sem o fazendeiro, o lobo come
% a cabra e a cabra come o repolho. Represente o estado por s(F,L,C,R), com
% cada posição em {e, d} (margem esquerda ou direita).
%  a) Defina mov(Estado,NovoEstado,Item), com os movimentos possíveis do barco
%     (Item é lobo, cabra, repolho ou nada, quando o fazendeiro atravessa
%     sozinho), e seguro(Estado), que rejeita estados em que alguém seria
%     comido.
%  b) Defina resolve(Plano), que encontre a sequência de itens transportados
%     do estado s(e,e,e,e) até s(d,d,d,d), sem repetir estados.
%  c) Quantos planos existem? Algum deles é mais curto que os outros?
%
% Comentário: Problema típico de busca em espaço de estados: é preciso modelar
% (1) o estado, (2) as transições, (3) as restrições de segurança e (4) o
% estado final. A lista de estados visitados evita ciclos (como atravessar e
% voltar com a mesma carga). A busca em profundidade não garante o plano mais
% curto em geral; para comparar, colete todos os planos com findall/3 e
% compare seus tamanhos. Aqui há exatamente dois planos sem estados repetidos,
% ambos com sete travessias.

%% --------------------------------------------------------------------------
%% 34) Avaliador de expressões com DCG  [DIFÍCIL]
%% --------------------------------------------------------------------------
% Os tokens de uma expressão aritmética vêm numa lista, por exemplo
% [2,+,3,*,4] ou ['(',2,+,3,')',*,4].
%  a) Escreva uma gramática DCG expr//1 que avalie a expressão, respeitando a
%     precedência (* e / antes de + e -), os parênteses e a associatividade à
%     esquerda. Teste com phrase(expr(V), Tokens).
%  b) Mostre que 10 - 4 - 3 deve resultar em 3 e não em 9. Como o seu programa
%     garante isso?
%  c) Explique por que a regra expr(V) --> expr(A), [+], termo(B), {V is A+B}.
%     faz o programa entrar em laço infinito.
%
% Comentário: Regras DCG são açúcar sintático: cada não terminal ganha dois
% argumentos extras (lista de entrada e lista restante, uma diferença de
% listas); {} insere metas Prolog comuns. A precedência vem da estrutura da
% gramática: expressões são somas de termos, termos são produtos de fatores. A
% associatividade à esquerda é obtida com um acumulador (resto_expr(Acc,V)),
% que combina o valor parcial com cada novo termo. Em (c), a regra com
% recursão à esquerda chama expr antes de consumir qualquer token, então a
% derivação nunca avança.

%% --------------------------------------------------------------------------
%% 35) SEND + MORE = MONEY  [DIFÍCIL]
%% --------------------------------------------------------------------------
% Atribua um dígito distinto a cada letra de modo que SEND + MORE = MONEY, com
% S e M diferentes de zero.
%  a) Defina puzzle([S,E,N,D,M,O,R,Y]) por gerar-e-testar, usando select/3
%     para gerar dígitos distintos.
%  b) Qual é a solução?
%  c) Deduza por raciocínio matemático o valor de M, fixe-o no programa e
%     compare os tempos de execução.
%  d) Descreva (sem implementar) como verificar a soma coluna a coluna para
%     podar mais cedo.
%
% Comentário: Cada select/3 retira um dígito ainda não usado, o que garante
% letras distintas: são 10P8 = 1.814.400 candidatos a testar. Como a soma de
% dois números de quatro dígitos é menor que 20000, M = 1; isso reduz o espaço
% para 9P7 = 181.440 candidatos, cerca de 10 vezes menos. No ambiente de teste
% (SWI-Prolog em WebAssembly) o tempo caiu de cerca de 1,9 s para 0,13 s. Em
% (d), a coluna das unidades (D + E) já determina Y e o vai-um, de modo que se
% pode testar cedo sem esperar todos os dígitos serem escolhidos.

%% ==========================================================================
%% GABARITO
%% ==========================================================================

% anexa/3 (exercício 12), usado nos exercícios 28 e 29
% anexa([],L,L).
% anexa([H|T],L,[H|R]) :- anexa(T,L,R).

%% --- 16) Animais: fatos e regras ---
% come_carne(X) :- animal(X,_,carnivoro).
% come_carne(X) :- animal(X,_,onivoro).
%
% mesma_classe(X,Y) :- animal(X,C,_), animal(Y,C,_), X \= Y.
%
% Exemplo: findall(X, come_carne(X), L) resulta em L =
% [leao,aguia,sapo,pardal].

%% --- 17) Aritmética básica ---
% maior(X,Y,X) :- X >= Y.
% maior(X,Y,Y) :- X < Y.
%
% par(N) :- N mod 2 =:= 0.
% impar(N) :- N mod 2 =:= 1.
%
% Exemplo: maior(3,7,M) resulta em M = 7. Respostas de impar/1 para
% [-3,0,4,7]: -3 e 7.

%% --- 18) Pertinência em lista ---
% pertence(X,[X|_]).
% pertence(X,[_|T]) :- pertence(X,T).
%
% Exemplo: pertence(X,[a,b,c]) enumera a, b, c.

%% --- 19) Tamanho de uma lista ---
% tamanho([],0).
% tamanho([_|T],N) :- tamanho(T,M), N is M+1.
%
% Exemplo: tamanho([a,b,c,d],N) resulta em N = 4.

%% --- 20) Dobro dos elementos ---
% dobros([],[]).
% dobros([X|T],[Y|R]) :- Y is 2*X, dobros(T,R).
%
% Exemplo: dobros([1,2,3],R) resulta em R = [2,4,6].

%% --- 21) Fatorial: recursão e acumulador ---
% fat(0,1).
% fat(N,F) :- N > 0, M is N-1, fat(M,G), F is N*G.
%
% fat_ac(N,F) :- fat_ac(N,1,F).
% fat_ac(0,A,A).
% fat_ac(N,A,F) :- N > 0, A1 is A*N, M is N-1, fat_ac(M,A1,F).
%
% Exemplo: fat(5,F) resulta em F = 120; fat_ac(6,F) resulta em F = 720.

%% --- 22) Fibonacci e memoização ---
% fib(0,0).
% fib(1,1).
% fib(N,F) :- N > 1, A is N-1, B is N-2, fib(A,FA), fib(B,FB), F is FA+FB.
%
% fibm(N,F) :- fib_memo(N,F), !.
% fibm(N,F) :- N < 2, !, F = N.
% fibm(N,F) :-
%     A is N-1, B is N-2,
%     fibm(A,FA), fibm(B,FB),
%     F is FA+FB,
%     assertz(fib_memo(N,F)).
%
% Exemplo: fibm(60,F) resulta em F = 1548008755920.

%% --- 23) Remoção de elementos ---
% remove(X,[X|T],T).
% remove(X,[H|T],[H|R]) :- remove(X,T,R).
%
% remove_todas(_,[],[]).
% remove_todas(X,[X|T],R) :- remove_todas(X,T,R).
% remove_todas(X,[H|T],[H|R]) :- X \= H, remove_todas(X,T,R).
%
% Exemplo: remove(a,[a,b,a,c],R) dá R = [b,a,c] e R = [a,b,c].
% remove_todas(a,[a,b,a,c,a],R) dá R = [b,c]. remove(a,L,[b,c]) dá [a,b,c],
% [b,a,c] e [b,c,a].

%% --- 24) Eliminação de repetidos ---
% sem_repetidos([],[]).
% sem_repetidos([H|T],R) :- pertence(H,T), !, sem_repetidos(T,R).
% sem_repetidos([H|T],[H|R]) :- sem_repetidos(T,R).
%
% sem_repetidos2([],[]).
% sem_repetidos2([H|T],R) :- memberchk(H,T), sem_repetidos2(T,R).
% sem_repetidos2([H|T],[H|R]) :- \+ memberchk(H,T), sem_repetidos2(T,R).
%
% Exemplo: sem_repetidos([a,b,a,c,b],R) resulta em R = [a,c,b] (uma única
% resposta, com as duas versões).

%% --- 25) Intercalação de listas ordenadas ---
% intercala([],L,L).
% intercala([X|Xs],[],[X|Xs]).
% intercala([X|Xs],[Y|Ys],[X|R]) :- X =< Y, intercala(Xs,[Y|Ys],R).
% intercala([X|Xs],[Y|Ys],[Y|R]) :- X > Y, intercala([X|Xs],Ys,R).
%
% Exemplo: intercala([1,4,9],[2,3,10,11],L) resulta em L = [1,2,3,4,9,10,11].

%% --- 26) Ordenação por inserção ---
% insere(X,[],[X]).
% insere(X,[Y|T],[X,Y|T]) :- X =< Y.
% insere(X,[Y|T],[Y|R]) :- X > Y, insere(X,T,R).
%
% ordena([],[]).
% ordena([H|T],S) :- ordena(T,ST), insere(H,ST,S).
%
% Exemplo: ordena([5,2,8,1,2],S) resulta em S = [1,2,2,5,8].

%% --- 27) Torres de Hanói ---
% hanoi(0,_,_,_).
% hanoi(N,O,D,A) :-
%     N > 0, M is N-1,
%     hanoi(M,O,A,D),
%     format('Move o disco ~w de ~w para ~w~n',[N,O,D]),
%     hanoi(M,A,D,O).
%
% movimentos(0,0).
% movimentos(N,M) :- N > 0, K is N-1, movimentos(K,MK), M is 2*MK+1.
%
% Exemplo: hanoi(3,a,c,b) imprime 7 movimentos; movimentos(10,M) resulta em M
% = 1023.

%% --- 28) Árvore binária de busca ---
% insere_arv(X,nil,arv(nil,X,nil)).
% insere_arv(X,arv(E,R,D),arv(E1,R,D)) :- X < R, insere_arv(X,E,E1).
% insere_arv(X,arv(E,R,D),arv(E,R,D1)) :- X > R, insere_arv(X,D,D1).
% insere_arv(X,arv(E,X,D),arv(E,X,D)).
%
% busca_arv(X,arv(_,X,_)).
% busca_arv(X,arv(E,R,_)) :- X < R, busca_arv(X,E).
% busca_arv(X,arv(_,R,D)) :- X > R, busca_arv(X,D).
%
% em_ordem(nil,[]).
% em_ordem(arv(E,R,D),L) :- em_ordem(E,LE), em_ordem(D,LD), anexa(LE,[R|LD],L).
%
% constroi([],nil).
% constroi([H|T],A) :- constroi(T,A0), insere_arv(H,A0,A).
%
% Exemplo: constroi([5,3,8,1,4],A) resulta em A =
% arv(arv(nil,1,arv(nil,3,nil)),4,arv(arv(nil,5,nil),8,nil)); em_ordem resulta
% em [1,3,4,5,8].

%% --- 29) Prefixo, sufixo e sublista ---
% prefixo(P,L) :- anexa(P,_,L).
% sufixo(S,L) :- anexa(_,S,L).
% sublista(S,L) :- anexa(_,T,L), anexa(S,_,T).
%
% Exemplo: sublista(S,[a,b]) dá [], [a], [a,b], [], [b], []: seis respostas,
% três delas vazias.

%% --- 30) findall, bagof e setof ---
% bem_pagos(L) :- findall(N, (emp(N,_,S), S > 4000), L).
%
% folha(D,T) :- findall(S, emp(_,D,S), Ss), sum_list(Ss,T).
%
% por_depto(D,L) :- setof(N, S^emp(N,D,S), L).
%
% media_depto(D,M) :-
%     bagof(S, N^emp(N,D,S), Ss),
%     sum_list(Ss,T), length(Ss,Q),
%     M is T/Q.
%
% Exemplo: bem_pagos(L): [ana,bia,noe,leo]. por_depto: rh-[eva,ivo,noe],
% ti-[ana,bia], vendas-[leo]. media_depto(rh,M): 3766.67; com setof o
% resultado seria 3900.

%% --- 31) Rotas em grafo com ciclos ---
% estrada(a,b,5).
% estrada(b,c,4).
% estrada(c,a,3).
% estrada(c,d,7).
% estrada(b,d,12).
% estrada(d,e,2).
% estrada(e,b,6).
%
% rota(A,B,R,D) :- caminho(A,B,[A],Rev,D), reverse(Rev,R).
%
% caminho(B,B,V,V,0).
% caminho(A,B,V,R,D) :-
%     estrada(A,C,K),
%     \+ member(C,V),
%     caminho(C,B,[C|V],R,D1),
%     D is D1+K.
%
% menor_rota(A,B,R,D) :-
%     findall(D1-R1, rota(A,B,R1,D1), L),
%     keysort(L,[D-R|_]).
%
% Exemplo: Rotas de a até e: [a,b,c,d,e] com 18 km e [a,b,d,e] com 19 km.
% menor_rota resulta em [a,b,c,d,e] com 18 km.

%% --- 32) N rainhas ---
% rainhas_gt(N,Qs) :- numlist(1,N,Ns), permutation(Ns,Qs), segura(Qs).
%
% segura([]).
% segura([Q|Qs]) :- sem_ataque(Q,Qs,1), segura(Qs).
%
% sem_ataque(_,[],_).
% sem_ataque(Q,[Q1|Qs],D) :-
%     Q =\= Q1+D, Q =\= Q1-D,
%     D1 is D+1,
%     sem_ataque(Q,Qs,D1).
%
% rainhas(N,Qs) :- numlist(1,N,Ns), coloca(Ns,[],Qs).
%
% coloca([],Qs,Qs).
% coloca(Livres,Postas,Qs) :-
%     select(Q,Livres,Resto),
%     sem_ataque(Q,Postas,1),
%     coloca(Resto,[Q|Postas],Qs).
%
% Exemplo: Há 4 soluções para N = 6 e 92 para N = 8. rainhas(8,Qs) resulta,
% por exemplo, em Qs = [4,2,7,3,6,8,5,1].

%% --- 33) Lobo, cabra e repolho ---
% oposto(e,d).
% oposto(d,e).
%
% mov(s(F,L,C,R), s(F1,L,C,R), nada)    :- oposto(F,F1).
% mov(s(F,F,C,R), s(F1,F1,C,R), lobo)   :- oposto(F,F1).
% mov(s(F,L,F,R), s(F1,L,F1,R), cabra)  :- oposto(F,F1).
% mov(s(F,L,C,F), s(F1,L,C,F1), repolho) :- oposto(F,F1).
%
% seguro(s(F,L,C,R)) :- \+ perigo(F,L,C,R).
% perigo(F,L,C,_) :- L == C, F \== C.
% perigo(F,_,C,R) :- C == R, F \== C.
%
% resolve(Plano) :- busca(s(e,e,e,e), [s(e,e,e,e)], Plano).
%
% busca(s(d,d,d,d),_,[]).
% busca(E,Visitados,[M|P]) :-
%     mov(E,E1,M),
%     seguro(E1),
%     \+ member(E1,Visitados),
%     busca(E1,[E1|Visitados],P).
%
% Exemplo: Planos (sete travessias cada):
% [cabra,nada,lobo,cabra,repolho,nada,cabra] e
% [cabra,nada,repolho,cabra,lobo,nada,cabra].

%% --- 34) Avaliador de expressões com DCG ---
% expr(V) --> termo(T), resto_expr(T,V).
% resto_expr(Acc,V) --> [+], termo(T), { Acc1 is Acc+T }, resto_expr(Acc1,V).
% resto_expr(Acc,V) --> [-], termo(T), { Acc1 is Acc-T }, resto_expr(Acc1,V).
% resto_expr(V,V) --> [].
%
% termo(V) --> fator(F), resto_termo(F,V).
% resto_termo(Acc,V) --> [*], fator(F), { Acc1 is Acc*F }, resto_termo(Acc1,V).
% resto_termo(Acc,V) --> [/], fator(F), { Acc1 is Acc/F }, resto_termo(Acc1,V).
% resto_termo(V,V) --> [].
%
% fator(V) --> [V], { number(V) }.
% fator(V) --> ['('], expr(V), [')'].
%
% Exemplo: Resultados: [2,+,3,*,4] dá 14; [(,2,+,3,),*,4] dá 20; [10,-,4,-,3]
% dá 3; [8,/,4,/,2] dá 1.

%% --- 35) SEND + MORE = MONEY ---
% puzzle([S,E,N,D,M,O,R,Y]) :-
%     Ds = [0,1,2,3,4,5,6,7,8,9],
%     select(S,Ds,D1), S > 0,
%     select(E,D1,D2),
%     select(N,D2,D3),
%     select(D,D3,D4),
%     select(M,D4,D5), M > 0,
%     select(O,D5,D6),
%     select(R,D6,D7),
%     select(Y,D7,_),
%     1000*S+100*E+10*N+D + 1000*M+100*O+10*R+E =:=
%         10000*M+1000*O+100*N+10*E+Y.
%
% puzzle_m1([S,E,N,D,1,O,R,Y]) :-
%     Ds = [0,2,3,4,5,6,7,8,9],
%     select(S,Ds,D1), S > 0,
%     select(E,D1,D2),
%     select(N,D2,D3),
%     select(D,D3,D4),
%     select(O,D4,D6),
%     select(R,D6,D7),
%     select(Y,D7,_),
%     1000*S+100*E+10*N+D + 1000+100*O+10*R+E =:=
%         10000+1000*O+100*N+10*E+Y.
%
% Exemplo: puzzle(L) resulta em [9,5,6,7,1,0,8,2] (S=9, E=5, N=6, D=7, M=1,
% O=0, R=8, Y=2): 9567 + 1085 = 10652.
