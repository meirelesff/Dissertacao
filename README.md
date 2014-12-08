Dissertacao
===========

Todos os arquivos necessários para gerar o .pdf final da minha dissertação estão aqui: `TeX` sources, o arquivo .bib com as referências, figuras, etc. Os `R-scripts` estão nesta pasta, e os dados para replicação só ficarão disponíveis depois que estiverem consolidados (algum dia).

**Customização com as normas ABNT da UFGRS**

Para adequar o Abntex2 às normas pedidas pelo PPGPOL da UFRGS, criei um arquivo .sty com algumas customizações necessárias, especificamente na capa, folhas de rosto e aprovação, fontes (*charter*) e  espaçamento. Para usá-la, basta pegar [esse arquivo .sty](https://github.com/meirelesff/Dissertacao/raw/master/PPGPOL.sty), colocar ele no diretório do teu projeto TeX e carregar ele no preâmbulo do arquivo com: 

`<\usepackage{PPGPOL}>`

