class_name SignalBus
extends Node

@warning_ignore("unused_signal")
signal mouse_entered_socket(socket:RocketSocketPoint)
@warning_ignore("unused_signal")
signal mouse_exited_socket
@warning_ignore("unused_signal")
signal socket_clicked(socket:RocketSocketPoint)
@warning_ignore("unused_signal")
signal player_grabbed_rocket_part_from_shop(rocket_part:RocketPartResource)
@warning_ignore("unused_signal")
signal rocket_part_added(rocket_resource:RocketPartResource)
@warning_ignore("unused_signal")
signal rocket_part_sold(rocket_part:RocketPart)
@warning_ignore("unused_signal")
signal player_release_left_click
@warning_ignore("unused_signal")
signal player_right_click
@warning_ignore("unused_signal")
signal rocket_launch
@warning_ignore("unused_signal")
signal physics_enabled
@warning_ignore("unused_signal")
signal rotate_cam_right
@warning_ignore("unused_signal")
signal rotate_cam_left

@warning_ignore("unused_signal")
signal rocket_tank_added(fuel:float)
@warning_ignore("unused_signal")
signal rocket_tank_removed(fuel:float)
@warning_ignore("unused_signal")
signal total_fuel_changed(total:float)
@warning_ignore("unused_signal")
signal rocket_fuel_changed(fuel_current:float,fuel_precentage:float)

## RocketRoot current height
@warning_ignore("unused_signal")
signal rocket_root_height_changed(height:float)

## Current score/money
@warning_ignore("unused_signal")
signal score_changed(new_score:int)
@warning_ignore("unused_signal")
signal current_height_changed(value:float)
@warning_ignore("unused_signal")
signal highscore_height_changed(value:float)
@warning_ignore("unused_signal")
signal meters_per_second_changed(value:float)

@warning_ignore("unused_signal")
signal root_destroyed
