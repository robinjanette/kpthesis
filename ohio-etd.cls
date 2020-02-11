\NeedsTeXFormat{LaTeX2e}[1995/12/01]
\ProvidesClass{ohio-etd}[2013/07/31 version 1.3 Ohio University Electronic
Thesis and Dissertation Class]

% 1.1 - change \listof to \addlistof to avoid conflict with float.sty
%     - load amsthm.sty since this must also precede txfonts.sty
%     - Thanks to Aleksey Imaev for pointing out these conflicts

% 1.2 - correct the copyright line to include the year before the name
%     - add "Page" to the table of contents and list of figures/tables

% 1.3 - Remove signature lines from "signature page" per ETD requirements
%     - Remove broken spacing code adding a newline at point of figure insertion
%     - Update graduation months for Semesters
%     - Add new "htc" option for HTC students. Adds \htcmajor, \htcdegree,
%       \htcdos, and \htcdean to front matter.
%	Updated by Samuel Jero <sj323707@ohio.edu>

% define some macros that allow the class to pass options to the underlying
% article.cls without causing erroneous error messages about unused options
\newcommand* \@leqno{\@gobble} 
\newcommand* \@fleqn{\@gobble} 
\newcommand* \@draft{\@gobble} 
\newcommand* \@fontsize{12pt}

\newif \if@pdftex   
\newif \if@htc  
\newif \if@numbered 
\newif \if@draft             
\newif \if@sstables 
\newif \if@coadvise
\newif \if@cmfont

\DeclareOption  {draft}    {\renewcommand*\@draft{draft}\@drafttrue}
\DeclareOption  {leqno}    {\renewcommand*\@fleqn{fleqn}}
\DeclareOption  {fleqn}    {\renewcommand*\@leqno{leqno}}
\DeclareOption  {11pt}     {\renewcommand*\@fontsize{11pt}}
\DeclareOption  {12pt}     {\renewcommand*\@fontsize{12pt}}
\DeclareOption  {cmfont}   {\@cmfonttrue}
\DeclareOption  {pdftex}   {\@pdftextrue}
\DeclareOption  {numbered} {\@numberedtrue}
\DeclareOption  {sstables} {\@sstablestrue}
\DeclareOption	{htc}      {\@htctrue}

\ExecuteOptions {12pt}
\ProcessOptions

\LoadClass[\@draft,\@fleqn,\@leqno,\@fontsize]{article}

\RequirePackage {lastpage} % count the number of pages
\RequirePackage {soul}     % underline titles across line break in the abstract
\RequirePackage {url}      % intelligent line breaks for URLs and DOIs
\urlstyle{same}

\AtEndOfClass{
  \RequirePackage[bookmarks, breaklinks, colorlinks,
                  linkcolor=black, urlcolor=black, citecolor=black]{hyperref}
}
\RequirePackage{amsmath,amsthm} % AMS math must be defined prior to txfonts
\if@cmfont\else\RequirePackage{txfonts}\fi % Times fonts versus Computer Modern

% provide the means to switch back and forth between single and double spacing, 
% adapted from the previous OU LaTeX class.
\newcommand* \singlespace{\renewcommand*\baselinestretch{1.0}\large\normalsize}
\newcommand* \@dsp{\renewcommand*\baselinestretch{1.655}\large\normalsize}

\newlength \@lineskip
\newlength \@fracskip
\newlength \@doubleskip
\setlength \@lineskip   {1.000\baselineskip}
\setlength \@fracskip   {0.655\baselineskip}
\setlength \@doubleskip {1.655\baselineskip}

\newcommand* \draftmode{\@drafttrue}
\AtBeginDocument{
  \if@draft  
    \singlespace
  \else
    \@dsp
  \fi
}

\newcounter{@appcount}
\AtEndDocument{
  \if@appendix
    \ifnum \c@chapter=\c@@appcount \else 
    \ClassWarningNoLine{ohio-etd}{appendix count has changed. 
                            Rerun to get labels right}
    \fi
    \immediate\write\@auxout{\string\setcounter{@appcount}{\number\c@chapter}}
  \else
    \immediate\write\@auxout{\string\setcounter{@appcount}{0}}
  \fi    
}

\setlength\paperheight    {11.0in}
\setlength\paperwidth     { 8.5in}
                          
\setlength\hoffset        {0in}
\setlength\voffset        {0in}
\setlength\marginparwidth {0in}     % no marginal notes
\setlength\marginparsep   {0in}
\setlength\marginparpush  {0in}    
\setlength\oddsidemargin  {0.5in}   % (in addition to the 1in default)
\setlength\evensidemargin {0.5in}   % (in addition to the 1in default)
\setlength\topmargin      {0in}     % (in addition to the 1in default)
\setlength\headheight     {\@lineskip} 
\setlength\headsep        {\@lineskip} 
\setlength\footskip       {0in}
                          
\setlength\textwidth      {\paperwidth}
\setlength\textheight     {\paperheight}

\addtolength \textwidth {-2in}      % 1in defaults for left and right margins
\addtolength \textwidth {-\oddsidemargin}
\addtolength \textheight{-2in}      % 1in defaults for top and bottom margins
\addtolength \textheight{-\headheight}
\addtolength \textheight{-\headsep}
\addtolength \textheight{-\footskip}

\renewcommand \topfraction      {1}
\renewcommand \textfraction     {0}
\renewcommand \floatpagefraction{.5}

\def\ps@headings{%
  \def\@oddhead {\hfil\thepage} % page number in top right corner
  \def\@evenhead{}
  \def\@oddfoot {}
  \def\@evenfoot{}
  \let\@mkboth\markboth
}

% MACROS FOR THE FRONTMATTER

\newcommand\degree[1]{
  \begingroup
    \def\deg{#1}
    \def\degMA{MA}
    \def\degMS{MS}
    \def\degMCTP{MCTP}
    \def\degPhD{PhD}
    \ifx\deg\degMA\endgroup
      \newcommand*\@degree{Master of Arts}
      \newcommand*\@degreeabbr{M.A.}     
      \newcommand*\@doctype{thesis}
      \newcommand*\@Doctype{Thesis}
    \else\ifx\deg\degMS\endgroup
      \newcommand*\@degree{Master of Science}
      \newcommand*\@degreeabbr{M.S.}     
      \newcommand*\@doctype{thesis}
      \newcommand*\@Doctype{Thesis}
    \else\ifx\deg\degMCTP\endgroup
      \newcommand*\@degree{Master of Communication Technology and Policy}
      \newcommand*\@degreeabbr{MCTP}                       
      \newcommand*\@doctype{thesis}
      \newcommand*\@Doctype{Thesis}
    \else\ifx\deg\degPhD\endgroup
      \newcommand*\@degree{Doctor of Philosophy}
      \newcommand*\@degreeabbr{Ph.D.} 
      \newcommand*\@doctype{dissertation}
      \newcommand*\@Doctype{Dissertation}
    \else\endgroup
      \ClassWarning{ohio-etd}{degree not recognized (expecting MA, MS, MCTP,
        or PhD)}
    \fi\fi\fi\fi
}

\newcommand*\graduation[2]{
  \begingroup
    \def\month{#1}
    \def\monthMar{May}
    \def\monthMay{August}
    \def\monthAug{December}
    \ifx\month\monthMar\endgroup\newcommand*\@gradmonth{#1}
    \else\ifx\month\monthMay\endgroup\newcommand*\@gradmonth{#1}
    \else\ifx\month\monthAug\endgroup\newcommand*\@gradmonth{#1}
    \else\ifx\month\monthNov\endgroup\newcommand*\@gradmonth{#1}
    \else
      \ClassWarning{ohio-etd}{graduation month not recognized (expecting May, August, or December)}
    \fi\fi\fi\fi
  \newcommand*\@gradyear{#2}   
}

\newcommand*\program[1]     {\newcommand*\@program{#1}}
\newcommand*\department[1]  {\newcommand*\@department{#1}}
\newcommand*\college[1]     {\newcommand*\@college{#1}}

\newcommand*\advisor[2]     {\newcommand*\@advisor{#1}
                             \newcommand*\@advisortitle{#2}}
\newcommand*\coadvisor[2]   {\newcommand*\@coadvisor{#1}
                             \newcommand*\@coadvisortitle{#2}\@coadvisetrue}
\newcommand*\dean[2]        {\newcommand*\@dean{#1}
                             \newcommand*\@deantitle{#2}}
\renewcommand*\author[2]    {\renewcommand*\@author{#1 #2}
                             \newcommand*\@authorreversed{#2, #1}}
\renewcommand\title[1]      {\renewcommand\@title{#1}}
\newcommand*\authorreversed[1]{\renewcommand*\@authorreversed{#1}}



\newcommand{\@centeredpage}[1]{  
  \newpage
  \vbox to \textheight{
    \vfil
    \begin{center}
      \@dsp 
      #1\par
      \vspace{\@doubleskip}
    \end{center}
    \vfil
  }
}
%HTC additions
\newcommand*\htcmajor[1]     {\newcommand*\@htcmajor{#1}}
\newcommand\htcdegree[1]{
  \begingroup
    \def\deg{#1}
    \def\degBA{BA}
    \def\degBS{BS}
    \ifx\deg\degBA\endgroup
      \newcommand*\@htcdegree{Bachelor of Arts}
      \newcommand*\@htcdegreeabbr{B.A.}     
      \newcommand*\@htcdoctype{thesis}
      \newcommand*\@htcDoctype{Thesis}
    \else\ifx\deg\degBS\endgroup
      \newcommand*\@htcdegree{Bachelor of Science}
      \newcommand*\@htcdegreeabbr{B.S.}     
      \newcommand*\@htcdoctype{thesis}
      \newcommand*\@htcDoctype{Thesis}
    \else\endgroup
      \ClassWarning{ohio-etd}{degree not recognized (expecting BA or BS)}
    \fi\fi
}
\newcommand*\htcdos[1]        {\newcommand*\@htcdos{#1}}
\newcommand*\htcdean[2]        {\newcommand*\@htcdean{#1}
                             \newcommand*\@htcdeantitle{#2}}
% FRONT MATTER

\newcommand\makefrontmatter{
  
  % error checking
  \begingroup
    \newif\if@ferr
    \@ferrfalse
    \@ifundefined{@degree}{
      \@ferrtrue\ClassWarningNoLine{ohio-etd}{missing degree}}{}
    \@ifundefined{@gradmonth}{
      \@ferrtrue\ClassWarningNoLine{ohio-etd}{missing graduation month}}{}
    \@ifundefined{@program}{
      \@ferrtrue\ClassWarningNoLine{ohio-etd}{missing program name}}{}
    \@ifundefined{@department}{
      \@ferrtrue\ClassWarningNoLine{ohio-etd}{missing department name}}{}
    \@ifundefined{@college}{
      \@ferrtrue\ClassWarningNoLine{ohio-etd}{missing college name}}{}
    \@ifundefined{@author}{
      \@ferrtrue\ClassWarningNoLine{ohio-etd}{missing author's name}}{}
    \@ifundefined{@title}{
      \@ferrtrue\ClassWarningNoLine{ohio-etd}{missing document's title}}{}
    \@ifundefined{@advisor}{
      \@ferrtrue\ClassWarningNoLine{ohio-etd}{missing advisor's information}}{}
    \@ifundefined{@dean}{
      \@ferrtrue\ClassWarningNoLine{ohio-etd}{missing dean's information}}{}
   	\if@htc
   		\@ifundefined{@htcmajor}{
   			\@ferrtrue\ClassWarningNoLine{ohio-etd}{missing HTC major}}{}
   		\@ifundefined{@htcdegree}{
   			\@ferrtrue\ClassWarningNoLine{ohio-etd}{missing HTC degree}}{}
   		\@ifundefined{@htcdos}{
   			\@ferrtrue\ClassWarningNoLine{ohio-etd}{missing HTC DOS information}}{}
   		\@ifundefined{@htcdean}{
   			\@ferrtrue\ClassWarningNoLine{ohio-etd}{missing HTC dean information}}{}
   	\fi
    \if@ferr 
      \ClassError{ohio-etd}{missing required frontmatter definitions}
                 {All frontmatter macros must be defined in the preamble}
    \fi
  \endgroup

  % print the frontmatter
  \@titlepage      
  \@govtdisclaimer 
  \@approvalpage   
  \@abstract       
  \@dedication     
  \@acknowledgments
  \tableofcontents 
  \@listoftables   
  \@listoffigures  
  \@makelist
  
%   \@otherlists
%   \@listofsymbols  
%   \@listofacronyms 

  % free up some memory
  \global\let\@pdftex          \@empty
  \global\let\@centeredpage    \@empty
  \global\let\@titlepage       \@empty
  \global\let\@govtdisclaimer  \@empty
  \global\let\@approved        \@empty
  \global\let\@approvalpage    \@empty
  \global\let\@abstract        \@empty
  \global\let\@dedication      \@empty
  \global\let\@acknowledgments \@empty
  \global\let\@listoftables    \@empty
  \global\let\@listoffigures   \@empty
  \global\let\@listofsymbols   \@empty
  \global\let\@listofacronyms  \@empty
  \global\let\govtdisclaimer   \relax
  \global\let\abstract         \relax
  \global\let\dedication       \relax
  \global\let\acknowledgments  \relax
  \global\let\acknowledgements \relax
  \global\let\listofsymbols    \relax
  \global\let\listofacronyms   \relax
  \global\let\tableofcontents  \relax
  \global\let\graduation       \relax
  \global\let\program          \relax
  \global\let\department       \relax
  \global\let\college          \relax
  \global\let\author           \relax
  \global\let\title            \relax
  \global\let\advisor          \relax
  \global\let\coadvisor        \relax
  \global\let\dean             \relax    
  \global\let\@degreeabbr      \@empty
  \global\let\@gradyear        \@empty
  \global\let\@gradmonth       \@empty
  \global\let\@program         \@empty
  \global\let\@department      \@empty
  \global\let\@college         \@empty
  \global\let\@author          \@empty
  \global\let\@title           \@empty
  \global\let\@advisor         \@empty
  \global\let\@coadvisor       \@empty
  \global\let\@deantitle       \@empty    
  \global\let\@advisortitle    \@empty
  \global\let\@coadvisortitle  \@empty
  \global\let\@dean            \@empty    
  \global\let\@signwidth       \@empty
}
  
\newcommand\@titlepage{
  \newpage
  \if@pdftex 
    \hypersetup{pdftitle={\@title},pdfauthor={\@author}} 
    % The following line accomodates transparency in PDF files
    \pdfpageattr {/Group << /S /Transparency /I true /CS /DeviceRGB>>}
  \fi
  \thispagestyle{empty}
  \setcounter{page}{1}
  \if@htc
	  \begin{center}
	    \@dsp
	    \@title\\[5\@doubleskip]
	    A \@doctype\ presented to\\
	    The Honors Tutorial College\\
	    Ohio University\\[\@doubleskip]
	    In partial fulfillment\\
	    of the Requirements for Graduation\\
	    from the Honors Tutorial College\\
	    with the degree of\\
	    \@htcdegree\ in \@htcmajor\\[5\@doubleskip]
	    \@author\\
	    \@gradmonth\ \@gradyear\\
	    \@ifundefined{govtdisclaimer}{}{
	      \copyright\ \@gradyear\ \@author. All Rights Reserved.
	    }
	  \end{center}
  \else
	  \begin{center}
	    \@dsp
	    \@title\\[5\@doubleskip]
	    A \@doctype\ presented to\\
	    the faculty of\\
	    the \@college\ of Ohio University\\[\@doubleskip]
	    In partial fulfillment\\
	    of the requirements for the degree\\
	    \@degree\\[5\@doubleskip]
	    \@author\\
	    \@gradmonth\ \@gradyear\\
	    \@ifundefined{govtdisclaimer}{}{
	      \copyright\ \@gradyear\ \@author. All Rights Reserved.
	    }
	  \end{center}
  \fi
  \setcounter{footnote}{0}
}

\let\@govtdisclaimer\relax % default to \relax so that the command can be
                           % issued in the frontmatter whether or not the
                           % \govtdisclaimer command is set in the preamble.
                           % Note that \let is required over \newcommand to
                           % later test with \@ifundefined
\newcommand\govtdisclaimer[1][
  The views expressed in this dissertation are those of the 
  author and do not reflect the official policy or position of
  the United States Air Force, the Department of Defense, \\ 
  or the United States Government.
]
{
  \@ifundefined{@govtdisclaimer}
    {\newcommand\@govtdisclaimer{\@centeredpage{#1}}}
    {\ClassWarning{ohio-etd}{ignoring subsequent \protect\govtdisclaimer}}
}

\newcommand*\@approved{Approved:\quad}
\settowidth \@tempdima{\@approved}
\newlength  \@signwidth
\setlength  \@signwidth\textwidth
\addtolength\@signwidth{-2\@tempdima}

\newcommand{\@approvalpage}{
  \newpage
  \if@htc
  	\begin{center}
	    \@dsp
	    This \@doctype\ has been approved by\\
	    The Honors Tutorial College and\\
	    The \@department\\[2\@doubleskip minus
	    1\@doubleskip] \underline{\hspace\@signwidth}\\
	    \@advisor\\
	    \@advisortitle\\
	    Thesis Advisor\\[2\@doubleskip minus 1\@doubleskip]
	    \if@coadvise
	      \underline{\hspace\@signwidth}\\
	      \@coadvisor\\
	      \@coadvisortitle\\
	      Thesis Advisor\\[2\@doubleskip minus 1\@doubleskip]
	    \fi
	    \underline{\hspace\@signwidth}\\
	    \@htcdos\\
	   	Honors Tutorial College, Director of Studies\\
	   	\@htcmajor\\[2\@doubleskip minus 1\@doubleskip]
	   	\underline{\hspace\@signwidth}\\
	   	\@htcdean\\
	   	\@htcdeantitle\\[2\@doubleskip minus 1\@doubleskip]
	   	\underline{\hspace\@signwidth}\\
	    \@dean\\
	    \@deantitle\\
	  \end{center}
  \else
	  \begin{center}
	    \@dsp
	    This \@doctype\ titled\\
	    \@title\\[2\@lineskip minus 3\@doubleskip]
	    by\\
	    \MakeUppercase{\@author}\\[1\@doubleskip]
	    has been approved for \\
	    the \@department\ \\
	    and the \@college\ by\\[3\@doubleskip minus 1\@doubleskip]
	    \@advisor\\
	    \@advisortitle\\[2\@doubleskip minus 1\@doubleskip]
	    \if@coadvise
	      \@coadvisor\\
	      \@coadvisortitle\\[2\@doubleskip minus 1\@doubleskip]
	    \fi
	    \@dean\\
	    \@deantitle\\
	  \end{center}
  \fi
}

\newcommand*\@last{\relax}
\newcommand*\@end{\null}
% Although forced line breaks may have been inserted into the title for the
% title page, these must be removed before printing the title on the approval
% page.
\def\@stripbreaks#1\\#2\@end{#1\if#2\@last\else\space\@stripbreaks#2\@end\fi}
\def\@tooneline{\expandafter\@stripbreaks\@title\\\@last\@end}
\let\@titleoneline=\@tooneline
\renewcommand\abstract[1]{
  \newcommand\@abstract{
    \@schaptertoc{Abstract}
    \begingroup
      \@dsp
      \begingroup
        \raggedright
        \MakeUppercase\@authorreversed,
        \@degreeabbr, \@gradmonth\ \@gradyear, \@program\\
        \ul\@titleoneline\ (\pageref{LastPage} pp.)\\
        \if@coadvise
          Directors of \@Doctype: \@advisor\ and \@coadvisor\\
        \else
          Director of \@Doctype: \@advisor\\
        \fi
      \endgroup
      #1 \\
      \noindent\centering
      %\@approved\hfil\\
    \endgroup
  }
}


\let\@dedication\relax
\newcommand\dedication[1]{
  \clearpage
  \@ifundefined{@dedication}
    {\newcommand\@dedication{\@schaptertoc{Dedication}#1}}
    {\ClassWarning{ohio-etd}{ignoring subsequent \protect\dedication}}
}


% \let\@dedication\relax
% \newcommand\dedication[1]{
%   \@ifundefined{@dedication}
%     { \newcommand\@dedication{\@schaptertoc{Dedication}#1
%         \clearpage
%         \refstepcounter{schapter}
%         \addcontentsline{toc}{chapter}{Dedication}
%         \@centeredpage{\emph{#1}}
%       }
%     
%     {\ClassWarning{ohio-etd}{ignoring subsequent \protect\dedication}}
% }
% }

\let\@acknowledgments\relax
\newcommand\acknowledgments[1]{
  \@ifundefined{@acknowledgments}
    {\newcommand\@acknowledgments{\@schaptertoc{Acknowledgments}#1}}
    {\ClassWarning{ohio-etd}{ignoring subsequent \protect\acknowledgments}}
}
\newcommand\acknowledgements[1]{
  \@ifundefined{@acknowledgments}
    {\newcommand\@acknowledgments{\@schaptertoc{Acknowledgements}#1}}
    {\ClassWarning{ohio-etd}{ignoring subsequent \protect\acknowledgements}}
}

\renewcommand\tableofcontents{
  \clearpage
  \if@pdftex \pdfbookmark[0]{Table of Contents}{TOC} \fi
  \chapter*{Table of Contents}
  \begingroup 
    \singlespace
    \hfill Page\par
    \@starttoc{toc}
  \endgroup
}

\newcounter{listctr}
\newcounter{listcnt}
\renewcommand\thelistcnt {\@Alph\c@listcnt}
\renewcommand\thelistctr {\@Alph\c@listctr}

\newcommand\@makelist{
  \ifnum \c@listcnt>\c@listctr
    \refstepcounter{listctr}
    \csname @listof\thelistctr \endcsname
    \@makelist
  \fi
}
  
\newcommand\addlistof[2]{
  \refstepcounter{listcnt}
  \expandafter\gdef\csname @listof\thelistcnt\endcsname{\@addlistof{#1}{#2}}
}

\newcommand\@addlistof[2]{
  \@schaptertoc{List of #1}
  \if@numbered\addvspace{\@lineskip}\fi
  \begingroup
    \singlespace
    #2
  \endgroup
}

\newcommand\@listoffigures{
  \setcounter{tocdepth}{1}
  \begingroup
    \let\numberline=\@numberlinefigure
    \@addlistof{Figures}{
      % add \@fracskip and \@lineskip to get correct spacing within the 
      % singlespace structure of the \@addlistof macro
      \if@numbered \addvspace{\@doubleskip} \noindent Figure 
      \else \addvspace{\@fracskip} \fi \hfill Page\par
      \addvspace{\@lineskip}
      \@starttoc{lof}
    }
  \endgroup
}

\newcommand\@listoftables{
  \setcounter{tocdepth}{1}
  \begingroup
    \let\numberline=\@numberlinetable
    \@addlistof{Tables}{
      % add \@fracskip and \@lineskip to get correct spacing within the 
      % singlespace structure of the \@addlistof macro
      \if@numbered \addvspace{\@doubleskip} \noindent Table 
      \else \addvspace{\@fracskip} \fi \hfill Page\par
      \addvspace{\@lineskip}
      \@starttoc{lot}
    }
  \endgroup
}

\newcommand\notables {\renewcommand\@listoftables{}}
\newcommand\nofigures{\renewcommand\@listoffigures{}}

\newcommand\references[1]{
  \clearpage
  \refstepcounter{schapter}
  \addcontentsline{toc}{chapter}{\bibname}
  \if@numbered\addvspace{\@doubleskip}\else\addvspace{\@fracskip}\fi
  \begingroup
    \singlespace 
    #1
  \endgroup
}

\newcommand*{\bibname}{References}
\renewenvironment{thebibliography}[1]{ 
  \@schaptertoc{\bibname}%
  \if@numbered\addvspace{\@doubleskip}\else\addvspace{\@fracskip}\fi
  \list{ \@biblabel{\@arabic\c@enumiv}}%
       { \settowidth\labelwidth{\@biblabel{#1}}%
         \leftmargin\labelwidth
         \advance\leftmargin\labelsep
         \usecounter{enumiv}%
         \let\p@enumiv\@empty
         \renewcommand\theenumiv{\@arabic\c@enumiv}
       }%
   \sloppy
   \clubpenalty4000
   \@clubpenalty \clubpenalty
   \widowpenalty4000
   \sfcode`\.\@m
   \singlespace
}
{\def\@noitemerr
  {\@latex@warning{Empty `thebibliography' environment}}%
  \endlist
}

\newif\if@appendix 
\renewcommand\appendix{
  \@appendixtrue
  \setcounter{chapter}{0}
  \renewcommand\thechapter {\@Alph\c@chapter}
  \ifnum \c@@appcount>1
    \newcommand*\@appname{Appendix\space\thechapter}
  \else
    \newcommand*\@appname{Appendix}
  \fi
  \if@numbered
    \addtocontents{lof} {\protect\addvspace{\@lineskip}}
    \addtocontents{lot} {\protect\addvspace{\@lineskip}}
  \fi
  \immediate\write\@auxout{\string\@writefile{toc}{%
      \string\setcounter{tocdepth}{0}}} % limit toc to Appendix title only
}

\newcounter{chapter}
\newcounter{schapter}
\renewcommand\thesection  {\thechapter.\@arabic\c@section}

\newcommand\chapter{
  \clearpage
   \global\@topnum\z@
   \@afterindenttrue
   \secdef\@chapter\@schapter
}

\def\@schapter#1{ % used by some bibliography packages
  \@makechapterhead{#1}
  \vspace{\@fracskip}
}

\newcommand\@schaptertoc[2][schapter]{
  \clearpage
  \global\@topnum\z@
  \@afterindenttrue
  \refstepcounter{#1}
  \addcontentsline{toc}{chapter}{#2}
  \@makechapterhead{#2}
}

\if@numbered

  \def\@chapter[#1]#2{
    \refstepcounter{chapter}
    \if@appendix
      \typeout{Appendix \thechapter.}
      \addcontentsline{toc}{chapter}{\@appname:\space#1}
      \@makechapterhead{\@appname:\space#2}
    \else
      \typeout{Chapter \thechapter.}
      \addcontentsline{toc}{chapter}{\protect\numberline{\thechapter}#1}
      \@makechapterhead{\thechapter\quad#2}
    \fi
    \addtocontents{lof}{\protect\addvspace{\@lineskip}}
    \addtocontents{lot}{\protect\addvspace{\@lineskip}}
  }

  \def\@makechapterhead#1{
    \begingroup
      \centering \sc \Large \bfseries #1 \par \nobreak
      \vspace{-\@fracskip}
      \addvspace{\@lineskip}
    \endgroup
    \@afterheading
  }
  \renewcommand\section{\@startsection {section}{1}{\z@}%
    {1.5ex \@plus -1ex \@minus -.2ex}{1.5ex \@plus.2ex}%
    {\normalfont\normalsize\bfseries}}
  \renewcommand\subsection{\@startsection{subsection}{2}{\z@}%
    {1.5ex\@plus -1ex \@minus -.2ex}{1.5ex \@plus .2ex}%
    {\normalfont\normalsize\bfseries}}
  \renewcommand\subsubsection{\@startsection{subsubsection}{3}{\z@}%
    {1.5ex\@plus -1ex \@minus -.2ex}{1.5ex \@plus .2ex}%
    {\normalfont\normalsize\bfseries}}
  \renewcommand\paragraph{\@startsection{paragraph}{4}{\z@}%
    {0ex\@plus -1ex \@minus -.2ex}{-1em}{\normalfont\normalsize\bfseries}}
  \renewcommand\subparagraph{\@startsection{subparagraph}{5}{\parindent}%
    {0ex \@plus1ex \@minus .2ex}{-1em}{\normalfont\normalsize\bfseries}}

  \@addtoreset {equation} {chapter}
  \@addtoreset {figure}   {chapter}
  \@addtoreset {table}    {chapter}
  \@addtoreset {section}  {chapter}

  \renewcommand \theequation {\thechapter.\@arabic\c@equation}
  \renewcommand \thefigure   {\thechapter.\@arabic\c@figure}
  \renewcommand \thetable    {\thechapter.\@arabic\c@table}

  \let\@numberlinefigure=\numberline
  \let\@numberlinetable= \numberline

  \renewcommand* \l@figure        {\@dottedtocline{1} {0em}   {2.3em}}
  \renewcommand* \l@table         {\@dottedtocline{1} {0em}   {2.3em}}
  \renewcommand* \l@section       {\@dottedtocline{1} {1.5em} {2.3em}}
  \renewcommand* \l@subsection    {\@dottedtocline{2} {3.8em} {3.2em}}
  \renewcommand* \l@subsubsection {\@dottedtocline{3} {7.0em} {4.1em}}
  \renewcommand* \l@paragraph     {\@dottedtocline{4} {10em}  {5em}}
  \renewcommand* \l@subparagraph  {\@dottedtocline{5} {12em}  {6em}}

\else

  \setcounter{secnumdepth}{0}
  \def\@chapter[#1]#2{
    \refstepcounter{chapter}
    \if@appendix
      \typeout{Appendix \thechapter.}
      \addcontentsline{toc}{chapter}{\@appname:\space#1}
      \@makechapterhead{\@appname:\space#2}
    \else
      \typeout{Chapter\space\thechapter.}
      \addcontentsline{toc}{chapter}{Chapter\space\thechapter: #1}
      \@makechapterhead{Chapter\space\thechapter: #2}
   \fi
  }
  \def\@makechapterhead#1{
    \begingroup
      \centering \uppercase\expandafter{#1} \par \nobreak
    \endgroup
    \@afterheading
 }
  \renewcommand\section{\@startsection {section}{1}{\z@}%
    {1sp}{1sp}{\normalfont\normalsize\centering}}
  \renewcommand\subsection{\@startsection{subsection}{2}{\z@}%
     {1sp}{1sp}{\normalfont\normalsize\itshape\centering}}
  \renewcommand\subsubsection{\@startsection{subsubsection}{3}{\z@}%
     {1sp}{1sp}{\normalfont\normalsize\itshape}}
  \renewcommand\paragraph{\@startsection{paragraph}{4}{\parindent}%
     {1sp}{1sp}{\normalfont\normalsize\itshape}}
  \renewcommand\subparagraph{\@startsection{subparagraph}{5}{\parindent}%
     {1sp}{-1em}{\normalfont\normalsize\itshape}}

  \newlength    \@figurelabel
  \settowidth   \@figurelabel{Figure:\nobreakspace}
  \addtolength  \@figurelabel{1.5em}
  \renewcommand*\l@figure{\@dottedtocline{1}{0em}{\@figurelabel}}

  \newlength    \@tablelabel
  \settowidth   \@tablelabel{Table:\nobreakspace}
  \addtolength  \@tablelabel{1.5em}
  \renewcommand*\l@table{\@dottedtocline{1}{0em}{\@tablelabel}}

  \renewcommand \theequation {\@arabic\c@equation}
  \renewcommand \thefigure   {\@arabic\c@figure}
  \renewcommand \thetable    {\@arabic\c@table}

  \newcommand\@numberlinefigure[1]{\hb@xt@\@tempdima{Figure #1\hfil}}
  \newcommand\@numberlinetable [1]{\hb@xt@\@tempdima{Table #1\hfil}}

  \renewcommand* \l@section       {\@dottedtocline{1} {1.5em} {0em}}
  \renewcommand* \l@subsection    {\@dottedtocline{2} {3em}   {0em}}
  \renewcommand* \l@subsubsection {\@dottedtocline{3} {4.5em} {0em}}
  \renewcommand* \l@paragraph     {\@dottedtocline{4} {6em}   {0em}}
  \renewcommand* \l@subparagraph  {\@dottedtocline{5} {7.5em} {0em}}

\fi

\setcounter{tocdepth}{3}

\def\fps@figure{tbh}
\def\fnum@figure{Figure\nobreakspace\thefigure}
\renewenvironment{figure}
               {\@float{figure}}
               {\end@float}

\def\fps@table{tbh}
\def\fnum@table{Table\nobreakspace\thetable}
\renewenvironment{table}
               { \if@sstables \singlespace \fi
                 \@float{table}
               }
               { \vspace{-\@lineskip}
                 \end@float
               }
\renewenvironment{table*}
               {\if@sstables \singlespace \fi
                \@dblfloat{table}}
               {\end@dblfloat}

\setlength\floatsep      {2\@doubleskip \@plus 1\p@ \@minus 1\p@}
\setlength\textfloatsep  {1\@doubleskip \@plus 1\p@ \@minus 1\p@}
\setlength\intextsep     {1\@doubleskip \@plus 1\p@ \@minus 1\p@}
\setlength\@fptop        {0\p@} % align float pages with the top of the page
\addtolength\textfloatsep\@lineskip

\setlength\abovecaptionskip{1ex}
\setlength\belowcaptionskip{1ex}
\long\def\@makecaption#1#2{%
  \expandafter\ifx#1\fnum@table 
  \else 
    \vskip \abovecaptionskip 
  \fi
  \sbox\@tempboxa{#1: #2}%
  \ifdim \wd\@tempboxa >\hsize
    \begingroup
      \singlespace #1: #2\par
    \endgroup
  \else
    \global \@minipagefalse
    \begingroup
      \singlespace \hb@xt@\hsize{\hfil\box\@tempboxa\hfil}%
    \endgroup
  \fi
  \expandafter\ifx#1\fnum@table 
    \vskip \belowcaptionskip
  \fi
}

\newcommand\l@chapter[2]{%
  \addpenalty{-\@highpenalty}%
  \setlength\@tempdima{1.5em}
  \begingroup
    \leavevmode
    \@dottedtocline{0}{0em}{1.5em}{#1}{#2}\par
    \nobreak
  \endgroup
}

\renewcommand\@makefntext[1]{%
  \noindent
  \hb@xt@2em{\hss\@makefnmark}
  \singlespace\footnotesize #1
}

\pagestyle{headings}
\raggedright
\setlength\parindent{2em} % must follow the \raggedright or will be reset to 0
\pretolerance=2000  
\clubpenalty =10000  
\widowpenalty=10000 
