#include "rwmake.ch"
#include "topconn.ch"
#include "protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
���������������������������������������������`���������������������������ͻ��
���Programa  �CXTEC01  �Autor  �Totvs Cascavel       � Data � 15/12/2014 ���
�������������������������������������������������������������������������͹��
���Desc.     �Fun��o respons�vel pela composi��o do c�digo do cliente ou  ���
���          �fornecedor a partir da informa��o do CNPJ\CPF quando n�o for���
���          �estrangeiro.                                                ���
�������������������������������������������������������������������������͹��
���Uso       �Especifico                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function CXTEC01(cTabela, lAtualiza)         

Local aArea			:= GetArea()
Local cAliasTMP			:= GetNextAlias()
Local cQuery			:= ""
Local cRet				:= STRZERO(1, TAMSX3("A1_LOJA")[1])        

Default cTabela		:= ""
Default lAtualiza		:= .F.

//������������������������������������������������������������
//�Executa demais regras caso o ALIAS tenha sido especificado�
//������������������������������������������������������������
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
		If (cAliasTMP)->(!EOF()) .AND. !EMPTY((cAliasTMP)->LOJA)
			cRet := SOMA1((cAliasTMP)->LOJA)
		EndIf                   
		
		(cAliasTMP)->(dbCloseArea())
	EndIf
EndIf

RestArea(aArea)

Return cRet