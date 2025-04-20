#set page(width: 8.5in, height: 11in, margin: 0.75in)
#set heading(numbering: "1.")

= Autômato Finito Determinístico para Jogo de Adivinhação


== Introdução
Este documento descreve a modelagem de um jogo de adivinhação numérica usando um Autômato Finito Determinístico (AFD). O sistema foi implementado em Rust e segue regras específicas de transição entre estados.

== Regras do Jogo
- *Objetivo*: Adivinhar um número entre 1 e 10 em até 3 tentativas
- *Feedback*:
  #list(
    [Palpite correto: vitória imediata],
    [Palpite alto/baixo: continuação do jogo],
    [3 erros consecutivos: derrota]
  )
- *Estados finais*: 
  #list(
    [Vitória: estado de aceitação],
    [Derrota: estado de rejeição]
  )

== Especificação do AFD

=== Definição Formal
O autômato é definido pela 5-tupla:
$ M = (Q, Σ, δ, q_0, F) $


Onde:
#list(
  [Estados (Q): S0, S1, S2, Vitória, Derrota],
  [Alfabeto (Σ): "correto", "alto", "baixo"],
  [Função de transição (δ): Tabela 1],
  [Estado inicial (q₀): S0],
  [Estados finais (F): Vitória]
)

#import "@preview/fletcher:0.5.7" as fletcher: diagram, node, edge

=== Diagrama de Estados

#fletcher.diagram(
    spacing: 2cm,
    node-stroke: 0.6pt,
    edge-stroke: 0.6pt,
    
    // Estados
    node((0, 0), "S0", name: <S0>, fill: luma(98%)),
    node((2, 0), "S1", name: <S1>, fill: luma(98%)),
    node((4, 0), "S2", name: <S2>, fill: luma(98%)),
    node((3, -2), "S3", name: <S3>, fill: blue.lighten(90%), extrude: (-2.5, 0)),
    node((6, 0), "S4", name: <S4>, fill: red.lighten(90%), extrude: (-2.5, 0)),
    
    // Transições principais
    edge(`alto/baixo`, "->", vertices: (<S0>, <S1>)),
    edge(`alto/baixo`, "->", vertices: (<S1>, <S2>)),
    edge(`alto/baixo`, "->", vertices: (<S2>, <S4>)),
    
    // Transições de vitória
   edge(`correto`, "->", bend: -30deg, vertices: (<S0>, <S3>)),
    edge(vertices:(<S1>, <S3>), `correto`, "->", bend: -30deg),
    edge(vertices: (<S2>, <S3>,), `correto`, "->", bend: -30deg),
)


=== Tabela de Transições
#table(
  columns: 3,
  align: center,
  [Estado Atual], [Entrada], [Próximo Estado],
  [S0], "correto", "Vitória",
  [S0], "alto/baixo", "S1",
  [S1], "correto", "Vitória",
  [S1], "alto/baixo", "S2",
  [S2], "correto", "Vitória",
  [S2], "alto/baixo", "Derrota",
)

== Implementação

=== Mapeamento para Código
Principais elementos da implementação em Rust:

#box()[
```Rust
#[derive(Debug, PartialEq)]
enum Estado {
    S0, S1, S2,
    Vitoria, Derrota
}
```
]

- *Transição de estados*: Função `transicionar_estado` implementa δ
- *Loop principal*: Controla fluxo do jogo até estados finais
- *Validação*: Garante entradas numéricas válidas

=== Fluxo de Execução
Inicia em S0 (3 tentativas)
  Recebe palpite do usuário
  Compara com número secreto
  Atualiza estado conforme feedback
  


== Análise de Complexidade
- *Espaço*: O(1) - número fixo de estados
- *Tempo*: O(n) - n = número máximo de tentativas (3)

== Conclusão
Este AFD modela eficientemente as regras do jogo através de:
#list(
  [Transições determinísticas],
  [Estados bem definidos],
  [Condições de parada claras]
)

O modelo pode ser estendido para:
#list(
  [Mais tentativas (adicionar estados S3, S4...)],
  [Faixa numérica maior],
  [Dificuldade progressiva]
)