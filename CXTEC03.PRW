#include "rwmake.ch"
#include "topconn.ch"
#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ`ÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CXTEC03  ºAutor  ³Totvs Cascavel       º Data ³ 05/01/2015 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função responsável pela composição do caractere sequencial  º±±
±±º          ³adicionado na composição do código de cliente\fornecedor se º±±
±±º          ³o mesmo for do tipo juridico.                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Especifico                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function CXTEC03(cTabela, lAtualiza)

Local aArea			:= GetArea()
Local cSeq				:= " "
Local cCnpj			:= ""
Local cQuery			:= ""
Local cAliasTMP		:= GetNextAlias()

Default cTabela		:= ""
Default lAtualiza		:= .F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Executa demais regras caso o ALIAS tenha sido especificado³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
If !EMPTY(cTabela)
	
	Do Case
		Case cTabela == "SA1" 
			cCnpj	:= IIF(lAtualiza, SA1->A1_CGC, M->A1_CGC)
			cQuery := " SELECT MAX(SA1.A1_COD) COD FROM " + RetSQLName("SA1") + " SA1 WHERE SA1.D_E_L_E_T_ <> '*' AND SA1.A1_CGC = '" + IIF(lAtualiza, SA1->A1_CGC, M->A1_CGC) + "'"
			
			If lAtualiza
				cQuery += " AND SA1.A1_X_COD <> '' AND SA1.A1_X_LOJA <> '' "
			EndIf
			
		Case cTabela == "SA2"
			cCnpj	:= IIF(lAtualiza, SA2->A2_CGC, M->A2_CGC)
			cQuery := " SELECT MAX(SA2.A2_COD) COD FROM " + RetSQLName("SA2") + " SA2 WHERE SA2.D_E_L_E_T_ <> '*' AND SA2.A2_CGC = '" + IIF(lAtualiza, SA2->A2_CGC, M->A2_CGC) + "'"
			
			If lAtualiza
				cQuery += " AND SA2.A2_X_COD <> '' AND SA2.A2_X_LOJA <> '' "
			EndIf
	EndCase
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Havendo query composta, executa a mesma³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	If !EMPTY(cQuery)
		TCQUERY ChangeQuery(cQuery) NEW ALIAS (cAliasTMP)
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³Compõe o código da loja a partir do último cadastro existente³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		dbSelectArea(cAliasTMP)
		(cAliasTMP)->(dbGoTop())
		If (cAliasTMP)->(!EOF()) .AND. !EMPTY((cAliasTMP)->COD)
			cSeq := SUBSTR(cCnpj,1,8) + SOMA1(SUBSTR((cAliasTMP)->COD, 9, 1))
		Else
			cSeq := SUBSTR(cCnpj,1,8) + cSeq
		EndIf                   
		
		(cAliasTMP)->(dbCloseArea())
	EndIf
EndIf

RestArea(aArea)

Return cSeq