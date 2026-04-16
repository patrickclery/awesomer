export interface Theme {
  '--background': string;
  '--foreground': string;
  '--accent': string;
  '--accent-hover': string;
  '--surface': string;
  '--surface-hover': string;
  '--border': string;
  '--muted': string;
  '--success': string;
  '--danger': string;
  '--warning': string;
  '--cyan': string;
  '--glow-color': string;
  '--selection-bg': string;
}

export const themes: Record<string, Theme> = {
  claude: {
    '--background': '#000000',
    '--foreground': '#d5d3ce',
    '--accent': '#00ff41',
    '--accent-hover': '#33ff66',
    '--surface': '#0a0a0a',
    '--surface-hover': '#111111',
    '--border': '#252525',
    '--muted': '#9e9c98',
    '--success': '#00ff41',
    '--danger': '#ff3333',
    '--warning': '#ffb800',
    '--cyan': '#00d4ff',
    '--glow-color': 'rgba(0, 255, 65, 0.4)',
    '--selection-bg': 'rgba(0, 255, 65, 0.15)',
  },

  'claude-code': {
    '--background': '#000000',
    '--foreground': '#d5d3ce',
    '--accent': '#c96a2b',
    '--accent-hover': '#e07d3a',
    '--surface': '#0a0a0a',
    '--surface-hover': '#111111',
    '--border': '#252525',
    '--muted': '#9e9c98',
    '--success': '#00ff41',
    '--danger': '#ff3333',
    '--warning': '#ffb800',
    '--cyan': '#00d4ff',
    '--glow-color': 'rgba(201, 106, 43, 0.4)',
    '--selection-bg': 'rgba(201, 106, 43, 0.15)',
  },

  selfhosted: {
    '--background': '#000000',
    '--foreground': '#d5d3ce',
    '--accent': '#F5801F',
    '--accent-hover': '#f99540',
    '--surface': '#0a0a0a',
    '--surface-hover': '#111111',
    '--border': '#252525',
    '--muted': '#9e9c98',
    '--success': '#00ff41',
    '--danger': '#ff3333',
    '--warning': '#ffb800',
    '--cyan': '#00d4ff',
    '--glow-color': 'rgba(245, 128, 31, 0.4)',
    '--selection-bg': 'rgba(245, 128, 31, 0.15)',
  },

  pirate: {
    '--background': '#0a0806',
    '--foreground': '#ddd0b5',
    '--accent': '#d4a024',
    '--accent-hover': '#e8b84a',
    '--surface': '#12100a',
    '--surface-hover': '#1a1610',
    '--border': '#3a3225',
    '--muted': '#8e7e68',
    '--success': '#5cb85c',
    '--danger': '#cc3333',
    '--warning': '#d4a024',
    '--cyan': '#5b9bd5',
    '--glow-color': 'rgba(212, 160, 36, 0.4)',
    '--selection-bg': 'rgba(212, 160, 36, 0.15)',
  },

  ruby: {
    '--background': '#0a0008',
    '--foreground': '#d8cbdd',
    '--accent': '#cc342d',
    '--accent-hover': '#e04840',
    '--surface': '#0f000a',
    '--surface-hover': '#180012',
    '--border': '#3a2035',
    '--muted': '#8e7088',
    '--success': '#5cb85c',
    '--danger': '#cc342d',
    '--warning': '#e8a02e',
    '--cyan': '#6bbfc0',
    '--glow-color': 'rgba(204, 52, 45, 0.4)',
    '--selection-bg': 'rgba(204, 52, 45, 0.15)',
  },

  docker: {
    '--background': '#030a12',
    '--foreground': '#c8d8ec',
    '--accent': '#0db7ed',
    '--accent-hover': '#3dc9f6',
    '--surface': '#061018',
    '--surface-hover': '#0c1a28',
    '--border': '#203a50',
    '--muted': '#6888a8',
    '--success': '#2ecc71',
    '--danger': '#e74c3c',
    '--warning': '#f1c40f',
    '--cyan': '#0db7ed',
    '--glow-color': 'rgba(13, 183, 237, 0.4)',
    '--selection-bg': 'rgba(13, 183, 237, 0.15)',
  },

  postgres: {
    '--background': '#03080e',
    '--foreground': '#c8d0da',
    '--accent': '#336791',
    '--accent-hover': '#4a82ab',
    '--surface': '#060e18',
    '--surface-hover': '#0c1825',
    '--border': '#283a50',
    '--muted': '#687888',
    '--success': '#2ecc71',
    '--danger': '#e74c3c',
    '--warning': '#f1c40f',
    '--cyan': '#5b9bd5',
    '--glow-color': 'rgba(51, 103, 145, 0.4)',
    '--selection-bg': 'rgba(51, 103, 145, 0.15)',
  },

  node: {
    '--background': '#020a02',
    '--foreground': '#c0d8ba',
    '--accent': '#68a063',
    '--accent-hover': '#8cc484',
    '--surface': '#061006',
    '--surface-hover': '#0c180c',
    '--border': '#283a28',
    '--muted': '#688a65',
    '--success': '#68a063',
    '--danger': '#cc3333',
    '--warning': '#e8a02e',
    '--cyan': '#5bbfc0',
    '--glow-color': 'rgba(104, 160, 99, 0.4)',
    '--selection-bg': 'rgba(104, 160, 99, 0.15)',
  },

  mac: {
    '--background': '#08080a',
    '--foreground': '#d0d0d8',
    '--accent': '#007aff',
    '--accent-hover': '#3395ff',
    '--surface': '#0e0e12',
    '--surface-hover': '#16161c',
    '--border': '#303042',
    '--muted': '#757588',
    '--success': '#30d158',
    '--danger': '#ff453a',
    '--warning': '#ffd60a',
    '--cyan': '#64d2ff',
    '--glow-color': 'rgba(0, 122, 255, 0.4)',
    '--selection-bg': 'rgba(0, 122, 255, 0.15)',
  },

  playwright: {
    '--background': '#000000',
    '--foreground': '#d5d3ce',
    '--accent': '#45BA4B',
    '--accent-hover': '#5ccd62',
    '--surface': '#0a0a0a',
    '--surface-hover': '#111111',
    '--border': '#252525',
    '--muted': '#9e9c98',
    '--success': '#45c44a',
    '--danger': '#D6382D',
    '--warning': '#ffb800',
    '--cyan': '#00d4ff',
    '--glow-color': 'rgba(192, 75, 65, 0.6)',
    '--selection-bg': 'rgba(69, 186, 75, 0.15)',
  },

  zsh: {
    '--background': '#000000',
    '--foreground': '#b8e0b8',
    '--accent': '#98c379',
    '--accent-hover': '#b5d8a0',
    '--surface': '#080c08',
    '--surface-hover': '#101810',
    '--border': '#283828',
    '--muted': '#6e8a6e',
    '--success': '#98c379',
    '--danger': '#e06c75',
    '--warning': '#e5c07b',
    '--cyan': '#56b6c2',
    '--glow-color': 'rgba(152, 195, 121, 0.4)',
    '--selection-bg': 'rgba(152, 195, 121, 0.15)',
  },

  catppuccin: {
    '--background': '#1e1e2e',
    '--foreground': '#cdd6f4',
    '--accent': '#cba6f7',
    '--accent-hover': '#b4befe',
    '--surface': '#313244',
    '--surface-hover': '#45475a',
    '--border': '#45475a',
    '--muted': '#a6adc8',
    '--success': '#a6e3a1',
    '--danger': '#f38ba8',
    '--warning': '#f9e2af',
    '--cyan': '#89dcfe',
    '--glow-color': 'rgba(203, 166, 247, 0.4)',
    '--selection-bg': 'rgba(203, 166, 247, 0.15)',
  },
};

export function getTheme(name: string | null | undefined): Theme {
  return themes[name ?? 'claude'] ?? themes.claude;
}

export function themeToStyle(theme: Theme): Record<string, string> {
  return { ...theme };
}
