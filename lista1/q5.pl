joga(ana,volei).
joga(bia,tenis).
joga(ivo,basquete).
joga(eva,volei).
joga(leo,tenis).

% a) ?- joga(P,X), joga(leo,X), P\=leo. O Prolog tenta resolver primeiro
% joga(P,X) com joga(ana,volei), fazendo P = ana e X = volei. Mas joga(leo,
% volei) é falso. A próxima tentativa é tentar resolver joga(P,X) com
% joga(bia,tenis), fazendo P = bia e X = tenis, como joga(leo,tenis) é
% verdadeiro e bia \= leo, é um ramo sucesso. A falha também acontece para P =
% ivo e X = basquete; P = eva e X = volei; e P = leo e X = volei (P deve ser \=
% de leo). O problema dessa consulta é colocar o literal mais genérico (com
% mais variáveis) mais à esquerda. 
%
% b) ?- joga(leo,X), joga(P,X), P\=leo. O Prolog tenta resolver joga(leo,X),
% fazendo X = tenis. Em seguida tenta resolver joga(P,tenis), fazendo P = bia.
