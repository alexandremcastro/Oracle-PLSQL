/* Questão 1 */
Select Cod_Profissional_Cinema,
       Count (Cod_Papel)                     As Total,
       Rank ()
         Over (
           Order By Count (Cod_Papel) Desc ) As Rank
From   Participacao
Group  By Cod_Profissional_Cinema; 

/* Questão 2 */
Create Table Ascendentes
  (
     Id   Number,
     Nome Varchar2,
     Mae  Number,
     Constraint Ascendentes_Constraint Unique (Id)
  ); 

-- Preenchendo a tabela Ascendentes.
Insert Into Ascendente
Values      ( 1,
             'Antônia Sophia Olivia Sales',
             Null );

Insert Into Ascendente
Values      ( 2,
             'Heloisa Emanuelly Viana',
             1 );

Insert Into Ascendente
Values      ( 3,
             'Melissa Olivia de Paula',
             1 );

Insert Into Ascendente
Values      ( 4,
             'Nicole Antônia Milena Teixeira',
             1 );

Insert Into Ascendente
Values      ( 5,
             'Fabiana Elisa da Rosa',
             2 );

Insert Into Ascendente
Values      ( 6,
             'Elisa Juliana Luana Teixeira',
             2 );

Insert Into Ascendente
Values      ( 7,
             'Tereza Lara Castro',
             2 );

Insert Into Ascendente
Values      ( 8,
             'Betina Kamilly Cavalcanti',
             3 );

Insert Into Ascendente
Values      ( 9,
             'Melissa Laís Santos',
             3 );

Insert Into Ascendente
Values      ( 10,
             'Bruna Clarice Vera Aparício',
             4 );

Insert Into Ascendente
Values      ( 11,
             'Francisca Lorena Alessandra Almeida',
             4 );

Insert Into Ascendente
Values      ( 12,
             'Marcela Hadassa Giovana Porto',
             4 );

Insert Into Ascendente
Values      ( 13,
             'Isadora Daniela da Paz',
             4 );

Insert Into Ascendente
Values      ( 14,
             'Rebeca Isabel Laís da Luz',
             5 );

Insert Into Ascendente
Values      ( 15,
             'Silvana Elza Carvalho',
             5 );

Insert Into Ascendente
Values      ( 16,
             'Nina Marli Isabelly Santos',
             6 );

Insert Into Ascendente
Values      ( 17,
             'Priscila Olivia Melissa dos Santos',
             7 );

Insert Into Ascendente
Values      ( 18,
             'Carolina Emily Fabiana Campos',
             7 );

Insert Into Ascendente
Values      ( 19,
             'Isabelly Sarah Rezende',
             8 );

Insert Into Ascendente
Values      ( 20,
             'Emilly Aurora Aline da Mata',
             8 );

Insert Into Ascendente
Values      ( 21,
             'Alexandre Castro',
             9 ); 

/* Questão 3 */
Select Level As Nivel,
       Id,
       Name,
       Mae
From   Ascendentes
Start With Id = 1
Connect By Prior Id = Mae; 

/* Questão 4 */
Select Level                    As Nivel,
       Id,
       Nome,
       Mae,
       Connect_By_Root ( Nome ) As Root,
       Connect_By_Isleaf        As Folha
From   Ascendentes
Start With Id In 1
Connect By Prior Id = Mae 

/* Questão 5 */
Alter Table Profissional_Cinema
  Add (Atuante Varchar (30) ); 

/* Questão 6 */
Create Or Replace Procedure Classificacao (Entry_Cod_Profissional_Cinema In Profissional_Cinema.Cod_Profissional_Cinema%Type)
Is
  V_Quantidade_Locacao Locacao.Cod_Filme%Type;
Begin
    Select Count (L.Cod_Filme)
    Into   V_Quantidade_Locacao
    From   Locacao Lo
           Join Participacao Pa
             On Lo.Cod_Filme = Pa.Cod_Filme
           Join Profissional_Cinema Pc
             On Pa.Cod_Profissional_Cinema = Pc.Cod_Profissional_Cinema
    Where  Pa.Cod_Profissional_Cinema = Entry_Cod_Profissional_Cinema;

    If V_Quantidade_Locacao > 50 Then
      Update Profissional_Cinema
      Set    Atuante = 'ALTA'
      Where  Cod_Profissional_Cinema = Entry_Cod_Profissional_Cinema;
    Elsif V_Quantidade_Locacao < 49
          And V_Quantidade_Locacao > 30 Then
      Update Profissional_Cinema
      Set    Atuante = 'MÉDIA'
      Where  Cod_Profissional_Cinema = Entry_Cod_Profissional_Cinema;
    End If;
End Classificacao; 

-- Executando a procedure Classificacao.
Exec Classificacao(1);

/* Questão 7 */
-- Descobrindo a média
Select Avg(Preco_Aplicado)
From   Locacao; 

-- Criando a procedure Muda_Preco.
Create Or Replace Procedure Muda_Preco (Entry_Cod_Filme In Locacao.Cod_Filme%Type)
Is
  Qnt_Vezes Number;
Begin
    Select Count (Cod_Filme)
    Into   Qnt_Vezes
    From   Locacao
    Where  Cod_Filme = Entry_Cod_Filme;

    If ( Qnt_Vezes > 49 ) Then
      Update Locacao
      Set    Preco_Aplicado = ( Preco_Aplicado * 1.10 );
    Else
      Update Locacao
      Set    Preco_Aplicado = ( Preco_Aplicado * 0.95 );
    End If;
End; 

-- Rodando a procedure Muda_Preco para os filmes com filme que possuem mais de 49 locações.
Exec Muda_Preco (13);

-- Rodando a procedure Muda_Preco para os filmes com filme que possuem menos de 49 locações.
Exec Muda_Preco (8);

/* Questão 8 */
-- Criando a procedure Deletar_Profissional.
Create Or Replace Procedure Deletar_Profissional (Entry_Cod_Profissional_Cinema Number)
Is
  V_Cod_Profissional_Cinema Participacao.Cod_Profissional_Cinema%Type;
  V_Erro Exception;
Begin
    Select Cod_Profissional_Cinema
    Into   V_Cod_Profissional_Cinema
    From   Profissional_Cinema
    Where  Cod_Profissional_Cinema = Entry_Cod_Profissional_Cinema;

    If ( V_Cod_Profissional_Cinema < 0 ) Then
      Raise V_Erro;
    Else
      Delete Profissional_Cinema
      Where  Cod_Profissional_Cinema = Entry_Cod_Profissional_Cinema
             And Entry_Cod_Profissional_Cinema Not In (Select Cod_Profissional_Cinema
                                                       From   Participacao);

      Dbms_Output.Put_Line('Profissional deletado com sucesso!');
    End If;
Exception
  When V_Erro Then
             Raise_Application_Error(-2292, 'Código do profissional não encontrado.');
End; 

-- Tentando deletar um profissional do cinema que possui participação em filmes.
Exec Deletar_Profissional(1);

-- Deletando um profissional do cinema que não possui participação em filmes.
Exec Deletar_Profissional(6);

/* Questão 09 */
-- Criando a procedure InsereNovoPapel

Create Or Replace Procedure InsereNovoPapel (Entry_Cod_Papel In Papel.Cod_Papel%Type,
                                             Entry_Descricao In Papel.Descricao%Type)
Is
  Validacao Exception;
  V_Cod_Papel Papel.Cod_Papel%Type;
  V_Descricao Papel.Descricao%Type;
Begin
    Select Cod_Papel,
           Descricao
    Into   V_Cod_Papel, V_Descricao
    From   Papel
    Where  Descricao = Entry_Descricao;

    If ( Entry_Descricao Is Not Null ) Then
      Raise Validacao;
    End If;
Exception
  When Validacao Then
    Dbms_Output.Put_Line('Não foi possível inserir um novo papel. O papel inserido já foi cadastrado');
  When No_Data_Found Then
    Insert Into Papel
                (Cod_Papel,
                Descricao)
    Values      ( Entry_Cod_Papel,
                Entry_Descricao);

    Dbms_Output.Put_Line('Papel inserido com sucesso!');
End; 

-- Executando a procedure InsereNovoPapel
Exec InsereNovoPapel(10, 'Alexandre');

/* Questão 10 */
-- Removendo as Constraints
Alter Table Participacao Drop Constraints FK_PARTICIPACAO_01;
Alter Table Participacao Drop Constraints FK_PARTICIPACAO_02;

-- Criando a Trigger SubstituirConstraints
Create Or Replace Trigger Substituirconstraints
  Before Insert Or Update On Participacao
  For Each Row
Declare
    V_Exception Exception;
    V_Confirmacao Number;
Begin
    Select Count(*)
    Into   V_Confirmacao
    From   Participacao
    Where  Cod_Filme = :New.Cod_Filme;

    If V_Confirmacao = 0 Then
      Dbms_Output.Put_Line('Não possui chave na tabela Participacao');

      Raise V_Exception;
    Else
      Dbms_Output.Put_Line('Possui chave na tabela Participacao');
    End If;
Exception
    When V_Exception Then
      Raise_Application_Error (Num =>- 20000, Msg => 'Cod_Filme existente na tabela');
End; 

/* Questão 11 */
-- Criação da Trigger Limite_20_Tables
Create Or Replace Trigger Limite_20_Tables
  Before Create On Schema
Declare
    V_Qnt Number;
    V_Erro Exception;
Begin
    Select Count (Table_Name)
    Into   V_Qnt
    From   All_Tables
    Where  Owner = 'Locadora';

    If ( V_Qnt >= 20 ) Then
      Raise V_Erro;
    Else
      Dbms_Output.Put_Line('Tabela criada com sucesso!');
    End If;
Exception
    When V_Eroo Then
      Raise_Application_Error(-20001, 'Tabela indisponível para criação');
End; 

/* Questão 12 */
-- Criando o package Package_Ins_Del_Sel.
Create Or Replace Package Package_Ins_Del_Sel
As
  Procedure InsereNovoPapel (
    Entry_Cod_Papel In Papel.Cod_Papel%Type,
    Entry_Descricao In Papel.Descricao%Type);
  Procedure EliminaPapel;
  Procedure ExibeMelhorPapel;
End Package_Ins_Del_Sel; 

-- Criando o package BODY Package_Ins_Del_Sel.
Create Or Replace Package Body
  Package_Ins_Del_Sel
As
    -- InsereNovoPapel
  Procedure InsereNovoPapel (Entry_Cod_Papel In Papel.Cod_Papel%Type,
                            Entry_Descricao In Papel.Descricao%Type)
  Is
    Validacao Exception;
    V_Cod_Papel Papel.Cod_Papel%Type;
    V_Descricao Papel.Descricao%Type;
  Begin
    Select Cod_Papel,
          Descricao
    Into   V_Cod_Papel,
          V_Descricao
    From   Papel
    Where  Descricao = Entry_Descricao;
    
    If ( Entry_Descricao Is Not Null ) Then
      Raise Validacao;
    End If;
  Exception
  When Validacao Then
    Dbms_Output.Put_Line('Não foi possível inserir um novo papel. O papel inserido já foi cadastrado');
  When No_Data_Found Then
    Insert Into Papel
      (
        Cod_Papel,
        Descricao
      )
      Values
      (
        Entry_Cod_Papel,
        Entry_Descricao
      );
    
    Dbms_Output.Put_Line('Papel inserido com sucesso!');
  End InsereNovoPapel;

  -- EliminaPapel 
  Procedure EliminaPapel
  Is
  Begin
    Delete
    From   Papel
    Where  Cod_Papel Not In
                            (
                            Select Distinct Cod_Papel
                            From            Participacao);

  Exception
  When Others Then
    Dbms_Output.Put_Line('Erro desconhecido.');
  End EliminaPapel;

  -- ExibeMelhorPapel --
  Create Or Replace Procedure Exibemelhorpapel
  Is
    V_Maisvezes Number;
  Begin
    Select   Count(Cod_Papel) As Maisvezes
    From     Participacao
    Group By Cod_Papel
    Order By Maisvezes Desc
    Fetch Next 1 Rows Only;
    
    Dbms_Output.Put_Line(V_Maisvezes);
  Exception
  When Others Then
    Dbms_Output.Put_Line('Erro desconhecido.');
  End Exibemelhorpapel;
End Package_Ins_Del_Sel;

-- Utilizando as procedures dentro do Package_Ins_Del_Sel.
Exec Package_Ins_Del_Sel.InsereNovoPapel(10, 'Alexandre');
Exec Package_Ins_Del_Sel.EliminaPapel();
Exec Package_Ins_Del_Sel.ExibeMelhorPapel();

/* Questão 13 */
-- Criando o Package_Ins_Del_Sel com a nova procedure VerificaDependencias.
Create Or Replace Package Package_Ins_Del_Sel
As
  Procedure InsereNovoPapel (
    Entry_Cod_Papel In Papel.Cod_Papel%Type,
    Entry_Descricao In Papel.Descricao%Type);
  Procedure EliminaPapel;
  Procedure ExibeMelhorPapel;
  Procedure VerificaDependencias(
    Entry_Tipo Varchar,
    Entry_Usuario Varchar,
    Entry_Tipo_Nome Varchar);
End Package_Ins_Del_Sel; 

-- Criando o Body Package_Ins_Del_Sel com a nova procedure VerificaDependencias.
Create Or Replace Package Body
  Package_Ins_Del_Sel
As
    -- InsereNovoPapel 
  Procedure InsereNovoPapel (Entry_Cod_Papel In Papel.Cod_Papel%Type,
                            Entry_Descricao In Papel.Descricao%Type)
  Is
    Validacao Exception;
    V_Cod_Papel Papel.Cod_Papel%Type;
    V_Descricao Papel.Descricao%Type;
  Begin
    Select Cod_Papel,
          Descricao
    Into   V_Cod_Papel,
          V_Descricao
    From   Papel
    Where  Descricao = Entry_Descricao;
    
    If ( Entry_Descricao Is Not Null ) Then
      Raise Validacao;
    End If;
  Exception
  When Validacao Then
    Dbms_Output.Put_Line('Não foi possível inserir um novo papel. O papel inserido já foi cadastrado');
  When No_Data_Found Then
    Insert Into Papel
      (
        Cod_Papel,
        Descricao
      )
      Values
      (
        Entry_Cod_Papel,
        Entry_Descricao
      );
    
    Dbms_Output.Put_Line('Papel inserido com sucesso!');
  End InsereNovoPapel;

  -- EliminaPapel
  Procedure EliminaPapel
  Is
  Begin
    Delete
    From   Papel
    Where  Cod_Papel Not In
                            (
                            Select Distinct Cod_Papel
                            From            Participacao);

  Exception
  When Others Then
    Dbms_Output.Put_Line('Erro desconhecido.');
  End EliminaPapel;

  -- ExibeMelhorPapel
  Create Or Replace Procedure Exibemelhorpapel
  Is
    V_Maisvezes Number;
  Begin
    Select   Count(Cod_Papel) As Maisvezes
    From     Participacao
    Group By Cod_Papel
    Order By Maisvezes Desc
    Fetch Next 1 Rows Only;
    
    Dbms_Output.Put_Line(V_Maisvezes);
  Exception
  When Others Then
    Dbms_Output.Put_Line('Erro desconhecido.');
  End Exibemelhorpapel;

  -- VerificaDependencias
  Procedure VerificaDependencias (Entry_Tipo      Varchar,
                                  Entry_Usuario   Varchar,
                                  Entry_Tipo_Nome Varchar)
  Is
  Begin
      Dbms_Output.Put_Line(Entry_Tipo, Entry_Usuario, Entry_Tipo_Nome);
  End VerificaDependencias; 
End Package_Ins_Del_Sel;

-- Utilizando as procedures dentro do Package_Ins_Del_Sel.
Exec Package_Ins_Del_Sel.InsereNovoPapel(10, 'Alexandre');
Exec Package_Ins_Del_Sel.EliminaPapel();
Exec Package_Ins_Del_Sel.ExibeMelhorPapel();
Exec Package_Ins_Del_Sel.VerificaDependencias('Table', 'Locadora', 'Profissional_Cinema');
