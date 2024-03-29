#include "rwmake.ch"
#include "topconn.ch"
#include "protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
���������������������������������������������`���������������������������ͻ��
���Programa  �CXTEC03  �Autor  �Totvs Cascavel       � Data � 05/01/2015 ���
�������������������������������������������������������������������������͹��
���Desc.     �Fun��o respons�vel pela composi��o do caractere sequencial  ���
���          �adicionado na composi��o do c�digo de cliente\fornecedor se ���
���          �o mesmo for do tipo juridico.                               ���
�������������������������������������������������������������������������͹��
���Uso       �Especifico                                          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function CXTEC03(cTabela, lAtualiza)

Local aArea			:= GetArea()
Local cSeq				:= " "
Local cCnpj			:= ""
Local cQuery			:= ""
Local cAliasTMP		:= GetNextAlias()

Default cTabela		:= ""
Default lAtualiza		:= .F.

//������������������������������������������������������������
//�Executa demais regras caso o ALIAS tenha sido especificado�
//������������������������������������������������������������
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
	
	//�����������������������������������������
	//�Havendo query composta, executa a mesma�
	//�����������������������������������������
	If !EMPTY(cQuery)
		TCQUERY ChangeQuery(cQuery) NEW ALIAS (cAliasTMP)
		
		//���������������������������������������������������������������
		//�Comp�e o c�digo da loja a partir do �ltimo cadastro existente�
		//���������������������������������������������������������������
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