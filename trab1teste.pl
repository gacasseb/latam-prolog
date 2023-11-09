% Defini��o de fatos para representar as cidades e as conex�es com pre�os

% Predicado para ler as informa��es das rotas a�reas do arquivo
ler_rotas(Arquivo) :-
    open(Arquivo, read, Stream),
    ler_linhas(Stream, Conexoes),
    close(Stream),
    assert(conexoes(Conexoes)).

% Predicado para ler todas as linhas do arquivo
ler_linhas(Stream, Conexoes) :-
    ler_linhas_aux(Stream, Conexoes).

ler_linhas_aux(Stream, Conexoes) :-
    read(Stream, Termo),
    (Termo == end_of_file -> Conexoes = [] ;
     Conexoes = [Termo | Resto],
     ler_linhas_aux(Stream, Resto)).

% Algoritmo para imprimir os voos
imprimir_conexoes :-
    findall((Origem, Destino, Preco), conexao(Origem, Destino, Preco), Conexoes),
    imprimir_lista_conexoes(Conexoes).

imprimir_lista_conexoes([]).
imprimir_lista_conexoes([(Origem, Destino, Preco) | Resto]) :-
    write('Voo de '), write(Origem),
    write(' para '), write(Destino),
    write(' com pre�o '), write(Preco), nl,
    imprimir_lista_conexoes(Resto).


% Algoritmo de Dijkstra
caminho_mais_curto(Origem, Destino, Caminho, Distancia) :-
    dijkstra([(0, Origem, [])], Destino, CaminhoReverso, Distancia),
    reverse(CaminhoReverso, Caminho).

dijkstra([], _, [], _).

dijkstra([(DistAtual, CidadeAtual, CaminhoAtual) | OutrosNodos], Destino, Caminho, Distancia) :-
    (CidadeAtual = Destino ->
        Caminho = CaminhoAtual, Distancia = DistAtual;
        findall((NovaDist, ProxCidade, [CidadeAtual | CaminhoAtual]),
            (conexao(CidadeAtual, ProxCidade, Preco),
             \+ member(ProxCidade, [CidadeAtual | CaminhoAtual]),
             NovaDist is DistAtual + Preco),
            NovosNodos),
        append(NovosNodos, OutrosNodos, TodosNodos),
        sort(TodosNodos, NodosOrdenados),
        dijkstra(NodosOrdenados, Destino, Caminho, Distancia)
    ).
