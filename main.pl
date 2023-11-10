
read_file(Filename) :-
    open(Filename, read, Stream),
    read_another(Stream),
    close(Stream).

% Read each term from the file and assert it as a fact
read_another(Stream) :-
    repeat,
    read_term(Stream, Term, []),
    (Term == end_of_file -> ! ; assert(Term), fail).

% Algoritmo para imprimir os voos
imprimir_conexoes :-
    findall((Origem, Destino, Preco), rotas(Origem, Destino, Preco), Conexoes),
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
        Caminho = [Destino | CaminhoAtual], Distancia = DistAtual;
        findall((NovaDist, ProxCidade, [CidadeAtual | CaminhoAtual]),
            (rotas(CidadeAtual, ProxCidade, Preco),
             \+ member(ProxCidade, [CidadeAtual | CaminhoAtual]),
             NovaDist is DistAtual + Preco),
            NovosNodos),
        append(NovosNodos, OutrosNodos, TodosNodos),
        sort(TodosNodos, NodosOrdenados),
        dijkstra(NodosOrdenados, Destino, Caminho, Distancia)
    ).