\NeedsTeXFormat{LaTeX2e}[1999/12/01]
\ProvidesClass{cookbook}[2011/08/06 v0.1 A class for typesetting cookbooks]
\LoadClassWithOptions{scrbook}

\usepackage{fontspec}
\usepackage{xcolor,xspace}
\usepackage[backend=biber]{biblatex}
\usepackage{makeidx,index}
\makeindex
\usepackage[german]{babel}
\usepackage{csquotes}
\usepackage{supertabular}
\usepackage{needspace}

\addbibresource{cookbooks.bib}

\usepackage{hyperref}

\setmainfont[Ligatures=TeX,Numbers=OldStyle]{Linux Libertine O}
\setsansfont[Ligatures=TeX,Numbers=OldStyle]{Linux Biolinum O}
\setmonofont[Ligatures=TeX]{Inconsolata}

\setkomafont{section}{\normalfont\normalcolor\scshape\Large\color{cyan!15!blue}}

\raggedbottom

%%% Recipe environment

\newif\ifck@haveinfo

\newenvironment{recipe}[1]{%
    \section*{#1}%
	\def\ck@recipename{#1}%
}{%
	\ck@haveinfofalse%
	\ifx\@source\@empty\else\ck@haveinfotrue\fi%
	\ifx\@yield\@empty\else\ck@haveinfotrue\fi%
	\ifx\@cf\@empty\else\ck@haveinfotrue\fi%
	\ifck@haveinfo%
	    \par\vspace{0.5\baselineskip}%
	\fi
	\ck@haveinfofalse
	\ifx\@yield\@empty\else
		\textsc{Menge:} \@yield\ %
		\ck@haveinfotrue
	\fi
	\ifx\@source\@empty\else
		\ifck@haveinfo · \fi%
    	\textsc{Quelle:} \@source\ %
		\ck@haveinfotrue
	\fi%
	\ifx\@cf\@empty\else%
		\ifck@haveinfo · \fi%
    	\textsc{Siehe auch:} \nameref{\@cf} (Seite \pageref{\@cf})\ %
		\ck@haveinfotrue
	\fi%
}

%%% Ingredients

\newenvironment{ingredients}{%%
	\begin{supertabular}{r@{\hspace{\unitspace}}l@{\ }p{5cm}}%
}{%
    \end{supertabular}\vspace{0.5\baselineskip}%
}

\def\entry{%
	\@ifnextchar[{\entry@}{\entry@[\ck@noamount]}%
}

\def\ck@nextcell{&}

\def\entry@[#1]#2{%
    \ck@havetableunitfalse
    \ck@tableunits
    #1
    \ifck@havetableunit\else\expandafter\ck@nextcell\fi
    & \raggedright\textit{#2} \tabularnewline
}

\def\entrysection#1{
	\multicolumn{3}{l}{\textsc{#1}} \\
}

\newif\ifck@havetableunit
\newcommand\tableunit[1]{%
	&#1%
	\ck@havetableunittrue%
}


%%% Instructions

\newenvironment{instructions}{}{}

%%% Further info

\let\@source\@empty
\def\source{%
    \@ifstar{\source@star}{\source@}%
}
\def\source@star{%
    \@ifnextchar[{\source@star@}{\source@star@[]}%
}
\def\source@star@[#1]#2{%
    \def\@source{\citetitle[#1]{#2} \cite{#2}}
}
\def\source@#1{\def\@source{#1}}

\newindex{region}{region.idx}{region.ind}{Recipes by Region}
\newcommand*\region[1]{%
	{\edef\tmp{[region]{#1!\ck@recipename}}%
	\expandafter\index\tmp}%
}

\newindex{ingredient}{ingredient.idx}{ingredient.ind}{Recipes by Ingredient}
\newcommand*\ingredient[1]{%
	{\edef\tmp{[ingredient]{#1!\ck@recipename}}%
	\expandafter\index\tmp}%
}

\let\@yield\@empty
\newcommand*\yield[1]{%
	\def\@yield{#1}
}

\let\@cf\@empty%
\newcommand*\cf[1]{
	\def\@cf{#1}
}

%%% Unit defititions

% Macros
\def\ck@tableunits{}

\newcommand\defineunit{%
	\@ifstar{\defineunit@star}{\defineunit@}%
}

\newcommand\defineunit@[2]{%
	\newcommand#1{\kern\unitspace #2\xspace}%
	\g@addto@macro\ck@tableunits{\def#1{\tableunit{#2}}}% For the definition of \tableunit see the ingredients section
}

\newcommand\defineunit@star[2]{%
	\newcommand#1{\ #2\xspace}%
	\g@addto@macro\ck@tableunits{\def#1{\tableunit{\kern-\unitspace\ #2}}}% For the definition of \tableunit see the ingredients section
}

\newcommand\redefineunit[2]{%
	\def#1{\kern\unitspace #2\xspace}%
	\g@addto@macro\ck@tableunits{\def#1{\tableunit{#2}}}% For the definition of \tableunit see the ingredients section
}

\newcommand\unitspace{0.05em}

% length
\defineunit\cm{cm}
\defineunit\inch{inch}

% volume
\defineunit\milliliter{ml}
\defineunit\millilitre{ml}
\defineunit\litre{l}
\defineunit\liter{l}
\defineunit\tl{\textsc{tl}}
\defineunit\el{\textsc{el}}
\defineunit\kl{\textsc{kl}}
\defineunit*\pkg{Pkg.}
\defineunit*\blatt{Blatt}
\defineunit*\blatter{Blätter}
\defineunit*\prise{Prise}
\defineunit*\bunch{bunch}
\defineunit*\packet{packet}
\defineunit*\packets{packets}
\redefineunit\cup{cup}
\defineunit\cups{cups}
\defineunit\tsp{tsp}
\defineunit\tbsp{tbsp}

% mass
\defineunit\gram{g}
\defineunit\kilogram{kg}
\defineunit\kg{kg}
\defineunit\pound{lbs}

% temperature
\defineunit\degC{\ensuremath{^\circ}C}
\defineunit\degF{\ensuremath{^\circ}F}
%\defineunit\degC{°C}

% time
\defineunit\minutes{min}

% for use in the table
\defineunit\ck@noamount{---}

\newcommand\half{½}
\newcommand\quarter{¼}
\newcommand\threequarter{¾}
\newcommand\third{⅓}
\newcommand\twothird{⅔}
\newcommand\eighth{⅛}
\newcommand\threeeighth{⅜}
\newcommand\onesixteenth{0.0625} %TODO: add symbols
\newcommand\twosixteenth{0.125}
\newcommand\threesixteenth{0.1875}
