extends Sprite

var shot = false


func _on_Area2D_area_shape_entered(area_id, area, area_shape, local_shape):
    if area.name == "ActiveRange" and not shot:
        $Wolf.play()
        $"/root/GGrimdarkControl".grimdark_level = $"/root/GGrimdarkControl".grimdark_level + 0.1
        shot = true
