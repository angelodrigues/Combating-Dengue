extends Node2D

@export var dialogos = [
	"Nossa cidade está enfrentando um grande perigo. Os mosquitos da dengue se multiplicam rapidamente, ameaçando a saúde de todos.", 
	"Eles botam ovos onde você nem imagina. O lixo espalhado pelo mapa acumula água parada, virando o berçário perfeito para o mosquito.",
	"Sua missão é combater a dengue pela raiz! Use W, A, S, D para se mover.",
	"Aperte F para recolher o lixo e eliminar os possíveis focos de água parada.",
	"De tempos em tempos, surgirá um frasco de Fumacê! Pegue-o com a tecla F para guardá-arlo.",
	"Quando a situação apertar, aperte E para ativar o Fumacê! Ele elimina os mosquitos da tela e te dá mais 10 segundos.",
	"O tempo corre e os mosquitos roubam seu tempo se encostarem em você! Limpe tudo antes que seja tarde demais."
]
var indice_fala = 0

func _ready():
	exibir_fala()

func exibir_fala():
	if indice_fala < dialogos.size():
		var fala_atual = dialogos[indice_fala]
		$tutorial.text = fala_atual
	else:
		finalizar_dialogo()

func _input(event):
	if event.is_action_pressed("ui_accept"): # Avança o texto ao pressionar Enter ou Espaço
		indice_fala += 1
		exibir_fala()

func finalizar_dialogo():
	$tutorial.hide() # Esconde o painel após o diálogo
	# Troca para a cena do primeiro nível
	get_tree().change_scene_to_file("res://management/game_level.tscn")
