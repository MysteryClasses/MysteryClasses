# MysteryClasses

A 2D mystery adventure game set in a university with different courses and classrooms. The player takes on the role of a student who must pass subjects by solving mysterious incidents happening around campus.

## Team Members
- **Hendrick** - Developer
- **Zhelong** - Developer  
- **Azra** - Developer
- **Hossei** - Developer

## Game Overview
Each course represents a different mystery. To succeed, the player must:
- Explore classrooms and university rooms
- Collect clues
- Interact with professors and other characters
- Solve puzzles

The player progresses by solving mysteries in each subject, uncovering a larger story behind the university.

## How to Run

### 1. Install Godot
- Download **Godot** from https://godotengine.org/download
- Install or extract Godot to your preferred location

### 2. Open the Project
- Launch Godot Engine
- Click **"Import"** on the project manager
- Navigate to this folder and select `project.godot`
- Click **"Open"**

### 3. Run the Game
- In Godot Editor, press **F5** or click the **Play** button (▶)
- The game window will open

## Project Configuration

### project.godot Settings
This is Godot's main configuration file that defines entire project settings:

**Basic Info:**
- `config_version=5` - Uses Godot 4.x configuration format
- `config/name="MysteryClasses"` - Game's name
- `run/main_scene="res://scenes/Main.tscn"` - What scene loads by pressing F5

**Display Settings:**
- Window size: 1280x720 pixels
- `window/size/mode=2` - Fullscreen mode
- `window/stretch/mode="canvas_items"` - How the game scales on different screen sizes

**Input Controls:**
You have 7 different input actions defined:
- `move_left` - A key or Left arrow
- `move_right` - D key or Right arrow  
- `move_up` - W key or Up arrow
- `move_down` - S key or Down arrow
- `interact` - E key or Spacebar
- `inventory` - I key
- `menu` - Escape key

**Graphics:**
- `renderer/rendering_method="gl_compatibility"` - Uses OpenGL for better compatibility across devices






