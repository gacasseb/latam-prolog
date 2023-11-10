% Predicado para ler um arquivo e assertar os termos como fatos
% +Filename: Nome do arquivo a ser lido
read_file(Filename) :-
    open(Filename, read, Stream),
    read_line(Stream),
    close(Stream).

% Predicado auxiliar para ler cada termo do arquivo e assertá-lo como um fato
% +Stream: O stream de leitura do arquivo
read_line(Stream) :-
    repeat,
    read_term(Stream, Term, []),
    (Term == end_of_file -> ! ; assert(Term), fail).

% Algoritmo para imprimir as conexões (voos) disponíveis
imprimir_conexoes :-
    findall((Origem, Destino, Preco), rotas(Origem, Destino, Preco), Conexoes),
    imprimir_lista_conexoes(Conexoes).

% Predicado auxiliar para imprimir a lista de conexões formatada
% +Lista: Lista de conexões no formato (Origem, Destino, Preço)
imprimir_lista_conexoes([]).
imprimir_lista_conexoes([(Origem, Destino, Preco) | Resto]) :-
    write('Voo de '), write(Origem),
    write(' para '), write(Destino),
    write(' com preço '), write(Preco), nl,
    imprimir_lista_conexoes(Resto).

% Algoritmo de Dijkstra para encontrar o caminho mais curto entre cidades
% +Origem: Cidade de origem
% +Destino: Cidade de destino
% -Caminho: Caminho mais curto entre origem e destino
% -Distancia: Distância total do caminho mais curto
caminho_mais_curto(Origem, Destino, Caminho, Distancia) :-
    dijkstra([(0, Origem, [])], Destino, CaminhoReverso, Distancia),
    reverse(CaminhoReverso, Caminho).

% Predicado auxiliar para implementar o algoritmo de Dijkstra
% +Nodos: Lista de nós a serem explorados, cada nó é representado como (Distância atual, Cidade atual, Caminho atual)
% +Destino: Cidade de destino
% -Caminho: Caminho mais curto reverso (será invertido no final)
% -Distancia: Distância total do caminho mais curto
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
