version = "1.1";

tree = {
	{
		Name = "APIs",
		IsDir = true,
		Content = {
			{
				Name = "stringExtAPI",
				IsDir = false
			},
			{
				Name = "tableExtAPI",
				IsDir = false
			},
			{
				Name = "xmlAPI",
				IsDir = false
			}
		}
	},
	{
		Name = "Classes",
		IsDir = true,
		Content = {
			{
				Name = "ApplicationClasses",
				IsDir = true,
				Content = {
					{
						Name = "Application.lua",
						IsDir = false
					},
					{
						Name = "ComponentsManager.lua",
						IsDir = false
					},
					{
						Name = "MenuesManager.lua",
						IsDir = false
					},
					{
						Name = "Thread.lua",
						IsDir = false
					},
					{
						Name = "ThreadsManager.lua",
						IsDir = false
					},
					{
						Name = "Window.lua",
						IsDir = false
					},
					{
						Name = "WindowsManager.lua",
						IsDir = false
					}
				}
			},
			{
				Name = "ComponentsClasses",
				IsDir = true,
				Content = {
					{
						Name = "Button.lua",
						IsDir = false
					},
					{
						Name = "CheckBox.lua",
						IsDir = false
					},
					{
						Name = "Component.lua",
						IsDir = false
					},
					{
						Name = "Edit.lua",
						IsDir = false
					},
					{
						Name = "FileBrowser.lua",
						IsDir = false
					},
					{
						Name = "HorizontalScrollBar.lua",
						IsDir = false
					},
					{
						Name = "Label.lua",
						IsDir = false
					},
					{
						Name = "ListBox.lua",
						IsDir = false
					},
					{
						Name = "PopupMenu.lua",
						IsDir = false
					},
					{
						Name = "ProgressBar.lua",
						IsDir = false
					},
					{
						Name = "VerticalScrollBar.lua",
						IsDir = false
					}
				}
			},
			{
				Name = "LongOS.lua",
				IsDir = false
			},
			{
				Name = "SystemClasses",
				IsDir = true,
				Content = {
					{
						Name = "ApplicationsManager.lua",
						IsDir = false
					},
					{
						Name = "ClassBase.lua",
						IsDir = false
					},
					{
						Name = "ConfigurationManager",
						IsDir = true,
						Content = {
							{
								Name = "ApplicationsConfiguration.lua",
								IsDir = false
							},
							{
								Name = "ColorConfiguration.lua",
								IsDir = false
							},
							{
								Name = "ConfigurationManager.lua",
								IsDir = false
							},
							{
								Name = "FileAssotiationsConfiguration.lua",
								IsDir = false
							},
							{
								Name = "InterfaceConfiguration.lua",
								IsDir = false
							},
							{
								Name = "MouseConfiguration.lua",
								IsDir = false
							}
						}
					},
					{
						Name = "ControlPanel.lua",
						IsDir = false
					},
					{
						Name = "Desktop.lua",
						IsDir = false
					},
					{
						Name = "EventHandler.lua",
						IsDir = false
					},
					{
						Name = "Graphics",
						IsDir = true,
						Content = {
							{
								Name = "Canvas.lua",
								IsDir = false
							},
							{
								Name = "Image.lua",
								IsDir = false
							},
							{
								Name = "Pixel.lua",
								IsDir = false
							},
							{
								Name = "VideoBuffer.lua",
								IsDir = false
							}
						}
					},
					{
						Name = "Logger.lua",
						IsDir = false
					},
					{
						Name = "Windows",
						IsDir = true,
						Content = {
							{
								Name = "ColorPickerDialog.lua",
								IsDir = false
							},
							{
								Name = "EnterTextDialog.lua",
								IsDir = false
							},
							{
								Name = "MessageWindow.lua",
								IsDir = false
							},
							{
								Name = "OpenFileDialog.lua",
								IsDir = false
							},
							{
								Name = "QuestionDialog.lua",
								IsDir = false
							},
							{
								Name = "SaveFileDialog.lua",
								IsDir = false
							}
						}
					}
				}
			}
		}
	},
	{
		Name = "Configuration",
		IsDir = true,
		Content = {
			{
				Name = "applications_configuration.xml",
				IsDir = false
			},
			{
				Name = "autoexec",
				IsDir = false
			},
			{
				Name = "color_schema.xml",
				IsDir = false
			},
			{
				Name = "file_assotiations_configuration.xml",
				IsDir = false
			},
			{
				Name = "interface_configuration.xml",
				IsDir = false
			},
			{
				Name = "mouse_configuration.xml",
				IsDir = false
			}
		}
	},
	{
		Name = "Loading.lua",
		IsDir = false
	},
	{
		Name = "Long",
		IsDir = false
	},
	{
		Name = "SystemUtilities",
		IsDir = true,
		Content = {
			{
				Name = "AboutSystem",
				IsDir = true,
				Content = {
					{
						Name = "AboutSystem.exec",
						IsDir = false
					},
					{
						Name = "AboutSystemWindow.lua",
						IsDir = false
					},
					{
						Name = "logotype.image",
						IsDir = false
					},
					{
						Name = "SystemUpdater.lua",
						IsDir = false
					},
					{
						Name = "UpdateSystemWindow.lua",
						IsDir = false
					}
				}
			},
			{
				Name = "ConfigurationManager",
				IsDir = true,
				Content = {
					{
						Name = "ApplicationConfigurationEditWindow.lua",
						IsDir = false
					},
					{
						Name = "ApplicationsConfigurationWindow.lua",
						IsDir = false
					},
					{
						Name = "ColorConfigurationWindow.lua",
						IsDir = false
					},
					{
						Name = "ConfigurationManager.exec",
						IsDir = false
					},
					{
						Name = "ConfigurationManagerWindow.lua",
						IsDir = false
					},
					{
						Name = "InterfaceConfigurationWindow.lua",
						IsDir = false
					},
					{
						Name = "MouseConfigurationWindow.lua",
						IsDir = false
					}
				}
			},
			{
				Name = "TasksManager",
				IsDir = true,
				Content = {
					{
						Name = "GvinTasksManager.exec",
						IsDir = false
					},
					{
						Name = "TasksManagerWindow.lua",
						IsDir = false
					}
				}
			},
			{
				Name = "Terminal",
				IsDir = true,
				Content = {
					{
						Name = "GvinTerminal.exec",
						IsDir = false
					},
					{
						Name = "GvinTerminalWindow.lua",
						IsDir = false
					},
					{
						Name = "RedirectorGenerator.lua",
						IsDir = false
					}
				}
			},
			{
				Name = "WallpaperManager",
				IsDir = true,
				Content = {
					{
						Name = "WallpaperManager.exec",
						IsDir = false
					},
					{
						Name = "WallpaperManagerWindow.lua",
						IsDir = false
					}
				}
			}
		}
	},
	{
		Name = "Utilities",
		IsDir = true,
		Content = {
			{
				Name = "BiriPaint",
				IsDir = true,
				Content = {
					{
						Name = "BiriPaint.exec",
						IsDir = false
					},
					{
						Name = "BiriPaintImageSizeDialog.lua",
						IsDir = false
					},
					{
						Name = "BiriPaintWindow.lua",
						IsDir = false
					}
				}
			},
			{
				Name = "Calculator",
				IsDir = true,
				Content = {
					{
						Name = "CalculatorWindow.lua",
						IsDir = false
					},
					{
						Name = "GvinCalculator.exec",
						IsDir = false
					}
				}
			},
			{
				Name = "FileManager",
				IsDir = true,
				Content = {
					{
						Name = "FileManagerWindow.lua",
						IsDir = false
					},
					{
						Name = "GvinFileManager.exec",
						IsDir = false
					}
				}
			}
		}
	},
	{
		Name = "Wallpapers",
		IsDir = true,
		Content = {
			{
				Name = "angry_birds.image",
				IsDir = false
			},
			{
				Name = "computer.image",
				IsDir = false
			},
			{
				Name = "creaper.image",
				IsDir = false
			},
			{
				Name = "girls-HD-60x40.image",
				IsDir = false
			}
		}
	}
};
