########################################
# ronbun_set_2021                      #
#                             Makefile #
#			2021/12/04 Tsuyoshi Ito    #
########################################

# メインファイルの名前
PREFIX   = main

# 各ファイル名
TEX_FILE = $(PREFIX).tex
DVI_FILE = $(PREFIX).dvi
PS_FILE  = $(PREFIX).ps
PDF_FILE = $(PREFIX).pdf
REF_FILE = ref.bib
# ソースファイル
SRCS     = $(shell find . -name \*.tex -or -name \img\*.eps)
$(eval DIR_NAME := $(shell pwd | sed 's,^\(.*/\)\?\([^/]*\),\2,'))	# ディレクトリ名取得
FINAL_FILE = $(DIR_NAME).pdf


.PHONY    : all dvi ps pdf help clean

# デフォルト
all : pdf

# 各オプション
dvi : $(DVI_FILE)
ps  : $(PS_FILE)
pdf : $(PDF_FILE)
pdfx: $(FINAL_FILE)

# ヘルプを表示
help :
	@ echo ""
	@ echo " make           make ps と同じ"
	@ echo " make dvi       .dvi ファイル生成"
	@ echo " make ps        .ps  ファイル生成"
	@ echo " make dvi       .pdf ファイル生成"
	@ echo ""
	@ echo " make help      このヘルプを表示"
	@ echo ""

# DVIファイル生成
# 目次のために2回実行
# 出力は同じなので2回目は表示しない
#
$(DVI_FILE) : $(SRCS) $(REF_FILE)
	@ platex $(TEX_FILE) #> /dev/null 2>&1
	@ pbibtex $(PREFIX)   # 2019.12.22追加 ref.bib用
	@ platex $(TEX_FILE)  > /dev/null 2>&1
	@ platex $(TEX_FILE)

$(PDF_FILE) : $(DVI_FILE) # hoge
	@ dvipdfmx $(DVI_FILE)

$(FINAL_FILE) : $(PDF_FILE)
	@ cp $(PDF_FILE) $(FINAL_FILE)

# クリーン
clean :
	@ rm -rf $(DVI_FILE) $(PS_FILE) $(PDF_FILE) $(FINAL_FILE) *.bak *.aux *.log *.toc *.bbl *.blg *.dvi *.ps *.blg


# PSファイル生成	# 処理hogeに統合
# $(PS_FILE) : $(DVI_FILE)
#	@ dvips -o $(PS_FILE) $(DVI_FILE)

# PDFファイル生成	# 処理hogeに統合
# $(PDF_FILE) : $(PS_FILE)
#	@ ps2pdf14 $(PS_FILE) $(PDF_FILE)
