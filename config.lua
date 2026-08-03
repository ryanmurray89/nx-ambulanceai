Config = {}
Config.Debug = false
Config.JobName = 'ambulance'
Config.RequireJob = true
Config.RewardType = 'cash'
Config.RewardAmount = 500
Config.RequiredItem = 'defib'
Config.CallChance = 65
Config.CallInterval = 5 -- minutes
Config.SceneCleanup = 5 -- minutes
Config.DispatchEnabled = true

Config.PedModels = {
    "a_m_m_business_01", "a_m_y_beach_01", "a_m_m_skater_01", "a_m_y_hipster_01",
    "a_f_y_bevhills_01", "a_f_m_bevhills_01", "s_m_y_construct_01", "a_m_m_genfat_01",
    "a_m_y_stbla_02", "a_f_y_eastsa_03"
}

Config.Injuries = {
    "Gunshot wounds to the chest", "Multiple stab wounds", "Hit by vehicle",
    "Severe overdose", "Blunt force trauma", "Fall from height", "Motorcycle accident",
    "Heavy bleeding from arm", "Unconscious after assault", "Possible cardiac arrest",
    "Burn injuries", "Head trauma from collision"
}

Config.SpawnLocations = {
    vector4(307.53, -595.21, 43.28, 159.0), vector4(1154.42, -1527.12, 34.84, 175.0),
    vector4(-254.23, 6333.12, 32.42, 90.0), vector4(1839.45, 3672.34, 34.27, 210.0),
    vector4(-449.22, -340.12, 34.50, 82.0), vector4(360.11, -1585.44, 29.29, 320.0),
    vector4(1200.54, -1460.22, 34.85, 180.0), vector4(-1803.91, -341.11, 44.10, 220.0),
    vector4(1692.55, 3581.44, 35.62, 110.0), vector4(-41.22, -1109.93, 26.43, 340.0)
}