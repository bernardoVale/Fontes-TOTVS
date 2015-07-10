#include "rwmake.ch"
#include "topconn.ch"
#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออ`ออออออออหออออออัออออออออออออปฑฑ
ฑฑบPrograma  ณCXTEC01  บAutor  ณTotvs Cascavel       บ Data ณ 15/12/2014 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo responsแvel pela composi็ใo do c๓digo do cliente ou  บฑฑ
ฑฑบ          ณfornecedor a partir da informa็ใo do CNPJ\CPF quando nใo forบฑฑ
ฑฑบ          ณestrangeiro.                                                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณEspecifico                                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function CXTEC01(cTabela, lAtualiza)         

Local aArea			:= GetArea()
Local cAliasTMP			:= GetNextAlias()
Local cQuery			:= ""
Local cRet				:= STRZERO(1, TAMSX3("A1_LOJA")[1])        

Default cTabela		:= ""
Default lAtualiza		:= .F.

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณExecuta demais regras caso o ALIAS tenha sido especificadoณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
If !EMPTY(cTabela)   

	Do Case
		Case cTabela == "SA1" 
			cQuery := " SELECT MAX(SA1.A1_LOJA) LOJA FROM " + RetSQLName("SA1") + " SA1 WHERE SA1.D_E_L_E_T_ <> '*' AND SA1.A1_CGC = '" + IIF(lAtualiza, SA1->A1_CGC, M->A1_CGC) + "'"
			
			If lAtualiza
				cQuery += " AND SA1.A1_X_COD <> '' AND SA1.A1_X_LOJA <> '' "
			EndIf
			
		Case cTabela == "SA2"
			cQuery := " SELECT MAX(SA2.A2_LOJA) LOJA FROM " + RetSQLName("SA2") + " SA2 WHERE SA2.D_E_L_E_T_ <> '*' AND SA2.A2_CGC = '" + IIF(lAtualiza, SA2->A2_CGC, M->A2_CGC) + "'"
			
			If lAtualiza
				cQuery += " AND SA2.A2_X_COD <> '' AND SA2.A2_X_LOJA <> '' "
			EndIf
	EndCase
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	//ณHavendo query composta, executa a mesmaณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	If !EMPTY(cQuery)
		TCQUERY ChangeQuery(cQuery) NEW ALIAS (cAliasTMP)
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
		//ณComp๕e o c๓digo da loja a partir do ๚ltimo cadastro existenteณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
		dbSelectArea(cAliasTMP)
		(cAliasTMP)->(dbGoTop())
		If (cAliasTMP)->(!EOF()) .AND. !EMPTY((cAliasTMP)->LOJA)
			cRet := SOMA1((cAliasTMP)->LOJA)
		EndIf                   
		
		(cAliasTMP)->(dbCloseArea())
	EndIf
EndIf

RestArea(aArea)

Return cRet