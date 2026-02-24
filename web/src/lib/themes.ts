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
    '--foreground': '#b3b1ad',
    '--accent': '#00ff41',
    '--accent-hover': '#33ff66',
    '--surface': '#0a0a0a',
    '--surface-hover': '#111111',
    '--border': '#1a1a1a',
    '--muted': '#555555',
    '--success': '#00ff41',
    '--danger': '#ff3333',
    '--warning': '#ffb800',
    '--cyan': '#00d4ff',
    '--glow-color': 'rgba(0, 255, 65, 0.4)',
    '--selection-bg': 'rgba(0, 255, 65, 0.15)',
  },

  pirate: {
    '--background': '#0a0806',
    '--foreground': '#c9b99a',
    '--accent': '#d4a024',
    '--accent-hover': '#e8b84a',
    '--surface': '#12100a',
    '--surface-hover': '#1a1610',
    '--border': '#2a2418',
    '--muted': '#6b5d4a',
    '--success': '#5cb85c',
    '--danger': '#cc3333',
    '--warning': '#d4a024',
    '--cyan': '#5b9bd5',
    '--glow-color': 'rgba(212, 160, 36, 0.4)',
    '--selection-bg': 'rgba(212, 160, 36, 0.15)',
  },

  ruby: {
    '--background': '#0a0008',
    '--foreground': '#c4b5c9',
    '--accent': '#cc342d',
    '--accent-hover': '#e04840',
    '--surface': '#0f000a',
    '--surface-hover': '#180012',
    '--border': '#2a1025',
    '--muted': '#6b5066',
    '--success': '#5cb85c',
    '--danger': '#cc342d',
    '--warning': '#e8a02e',
    '--cyan': '#6bbfc0',
    '--glow-color': 'rgba(204, 52, 45, 0.4)',
    '--selection-bg': 'rgba(204, 52, 45, 0.15)',
  },

  docker: {
    '--background': '#030a12',
    '--foreground': '#b0c4de',
    '--accent': '#0db7ed',
    '--accent-hover': '#3dc9f6',
    '--surface': '#061018',
    '--surface-hover': '#0c1a28',
    '--border': '#142a3e',
    '--muted': '#4a6a8a',
    '--success': '#2ecc71',
    '--danger': '#e74c3c',
    '--warning': '#f1c40f',
    '--cyan': '#0db7ed',
    '--glow-color': 'rgba(13, 183, 237, 0.4)',
    '--selection-bg': 'rgba(13, 183, 237, 0.15)',
  },

  postgres: {
    '--background': '#03080e',
    '--foreground': '#aeb8c4',
    '--accent': '#336791',
    '--accent-hover': '#4a82ab',
    '--surface': '#060e18',
    '--surface-hover': '#0c1825',
    '--border': '#1a2a3d',
    '--muted': '#4a5a6a',
    '--success': '#2ecc71',
    '--danger': '#e74c3c',
    '--warning': '#f1c40f',
    '--cyan': '#5b9bd5',
    '--glow-color': 'rgba(51, 103, 145, 0.4)',
    '--selection-bg': 'rgba(51, 103, 145, 0.15)',
  },

  node: {
    '--background': '#020a02',
    '--foreground': '#a8c4a0',
    '--accent': '#68a063',
    '--accent-hover': '#8cc484',
    '--surface': '#061006',
    '--surface-hover': '#0c180c',
    '--border': '#1a2a1a',
    '--muted': '#4a6a48',
    '--success': '#68a063',
    '--danger': '#cc3333',
    '--warning': '#e8a02e',
    '--cyan': '#5bbfc0',
    '--glow-color': 'rgba(104, 160, 99, 0.4)',
    '--selection-bg': 'rgba(104, 160, 99, 0.15)',
  },

  mac: {
    '--background': '#08080a',
    '--foreground': '#b8b8c0',
    '--accent': '#007aff',
    '--accent-hover': '#3395ff',
    '--surface': '#0e0e12',
    '--surface-hover': '#16161c',
    '--border': '#222230',
    '--muted': '#555566',
    '--success': '#30d158',
    '--danger': '#ff453a',
    '--warning': '#ffd60a',
    '--cyan': '#64d2ff',
    '--glow-color': 'rgba(0, 122, 255, 0.4)',
    '--selection-bg': 'rgba(0, 122, 255, 0.15)',
  },

  zsh: {
    '--background': '#000000',
    '--foreground': '#a0d0a0',
    '--accent': '#98c379',
    '--accent-hover': '#b5d8a0',
    '--surface': '#080c08',
    '--surface-hover': '#101810',
    '--border': '#1a261a',
    '--muted': '#506850',
    '--success': '#98c379',
    '--danger': '#e06c75',
    '--warning': '#e5c07b',
    '--cyan': '#56b6c2',
    '--glow-color': 'rgba(152, 195, 121, 0.4)',
    '--selection-bg': 'rgba(152, 195, 121, 0.15)',
  },
};

export function getTheme(name: string | null | undefined): Theme {
  return themes[name ?? 'claude'] ?? themes.claude;
}

export function themeToStyle(theme: Theme): Record<string, string> {
  return { ...theme };
}
