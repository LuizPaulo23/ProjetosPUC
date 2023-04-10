

notas = []  # criar uma lista vazia para armazenar as notas
for i in range(10):  # loop para ler as 10 notas
    nota = float(input(f"Informe a nota do aluno {i+1}: "))
    while nota < 0 or nota > 10:  # verificar se a nota é válida (entre 0 e 10)
        nota = float(input("Nota inválida! Informe uma nota entre 0 e 10: "))
    notas.append(nota)  # adicionar a nota à lista

maior_nota = max(notas)  # encontrar a maior nota na lista
menor_nota = min(notas)  # encontrar a menor nota na lista

print(f"A maior nota da turma é {maior_nota} e a menor nota é {menor_nota}.")
