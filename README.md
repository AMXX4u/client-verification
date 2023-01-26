<div align="center">

## Client Verification

<img src="https://raw.githubusercontent.com/AMXX4u/client-verification/main/assets/veri.png"></img>

</div>

<p align="center">
  <a href="#requirements">Wymagania ℹ</a> ×
  <a href="#description">Opis 📄</a> ×
  <a href="#configure">Konfiguracja 🛠</a> ×
  <a href="#screenshots">Screenshot 📷</a>
</p>

---

### Description 
- Plugin, który pomaga administracji z cziterami
- Plugin blokuje/wyrzuca podejrzanych graczy, którzy wchodzą na nietypowych wersjach Counter-Strike (Non-Steam)
- Blokowanie graczy można włączyć/wyłaczyć przez proste menu
- W menu również można wyrzucić podejrzanych graczy w trakcie gry za pomocą jednego kliknięcia
- W menu znajdziecie również liste graczy, po kliknięciu w gracza (jeżeli jest podejrzany) zostanie wyrzucony z serwera
- W menu, każdy podejrzany gracz **może** posiadać specjalny znak przy swoim nicku, który ustawiamy przez cvar
- Powód wyrzucenia (kicka), możecie ustawić przez cvar.

### Configure
<details>
  <summary><b>Cvars</b></summary>

```cfg
// Powód wyrzucenia podejrzanych graczy/a
amxx4u_kick_reason  "AMXX4u.pl - Client blocked"

// Wyświetlać tylko podejrzanych graczy w menu?
amxx4u_show_suspects  "0"

// Znak wyświetlany przy podejrzanych
amxx4u_client_mark  "#"

// Wyświetlać znak (#) przy?
amxx4u_mark_suspects

```
</details>


### Screenshots

<details>
  <summary><b>Client</b></summary>

- Menu

  <img src="https://github.com/AMXX4u/client-verification/blob/main/assets/menu.png?raw=true"></img>
  
- Kick Disabled

  <img src="https://github.com/AMXX4u/client-verification/blob/main/assets/kick_disabled.png?raw=true"></img>

- Kick Enabled

  <img src="https://github.com/AMXX4u/client-verification/blob/main/assets/kick_enabled.png?raw=true"></img>
  
- None suspects player

  <img src="https://github.com/AMXX4u/client-verification/blob/main/assets/none_player.png?raw=true"></img>
  
- None suspects

  <img src="https://github.com/AMXX4u/client-verification/blob/main/assets/none_suspects.png?raw=true"></img>
  
- Suspects Mark

  <img src="https://github.com/AMXX4u/client-verification/blob/main/assets/suspects_mark.png"></img>
</details>


### Requirements 
- AMXModX 1.9 / AMXModX 1.10
- ReHLDS 3.12.0.780
- ReAPI 5.21.0.252
